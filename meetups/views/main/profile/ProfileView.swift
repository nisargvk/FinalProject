//
//  ProfileView.swift
//  meetups
//
//  Created by Hryhorii Pievniev on 28.10.2020.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject() var authViewModel: AuthViewModel
    @EnvironmentObject() var userViewModel: UserViewModel
    
    @State private var username:String = ""
    @State private var usernameErrorMessage: String = ""
    
    @State private var showPasswordChange: Bool = false
    @State private var showImagePicker : Bool = false
    @State private var showProfileImageError : Bool = false
    
    @State private var uploadingImage : Bool = false
    @State private var savingUsername : Bool = false

    @State private var image : UIImage? = UIImage(named: "image-placeholder")
    
    private func loadImage(urlString: String) {
        let url = URL(string: urlString)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)

            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
    }
    
    private func uploadImage() {
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        self.uploadingImage = true
        
        self.userViewModel.editProfileImage(profileImage: imageData) { error in
            self.uploadingImage = false
            
            if error != nil {
                self.showProfileImageError = true
            }
        }
    }
    
    private func onLoaded() {
        let urlString = userViewModel.userProfile.profileImage
        
        if verifyUrl(urlString: urlString) {
            self.loadImage(urlString: urlString)
        }

        self.username = userViewModel.userProfile.username
    }
    
    private func onSaveUsername() {
        if self.username == self.userViewModel.userProfile.username {
            return
        }
        
        let usernameError = validateUsername(username: self.username)
        
        usernameErrorMessage = usernameError ?? ""
        
        if usernameError == nil {
            savingUsername = true

            self.userViewModel.changeUsername(newUsername: username) { error in
                savingUsername = false
            }
        }
    }
    
    private func onChooseImage() {
        if !uploadingImage {
            self.showImagePicker = true
        }
    }
    
    private func onSignOut() {
        self.authViewModel.signOut()
    }
    
    var body: some View {
        let isImageSelected = Binding<Bool>(
            get: {
                return true
            },
            set: {
                if $0 {
                    self.uploadImage()
                }
            }
        )
        
        return VStack(alignment: .center, spacing: 0) {
            Button(action: self.onChooseImage){
                Image(uiImage: image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150, alignment: .center)
                    .clipShape(Circle())
            }.padding(.bottom, 15)
            .sheet(isPresented: self.$showImagePicker) {
                ImagePicker(isShown: $showImagePicker, isSelected: isImageSelected, image: $image)
            }
            .alert(isPresented: $showProfileImageError) {
                Alert(
                    title: Text("Image upload up failed"),
                    message: Text("An error occured. Please try again later.")
                )
            }
            
            Text(self.userViewModel.userProfile.email)
                .padding(.bottom, 15)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    TextField("Username", text:
                                $username)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .autocapitalization(.none)
                    

                    Button(action: onSaveUsername) {
                        Text(savingUsername ? "Saving..." : "Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 55)
                            .background(
                                Color(UIColor(Color.orange)
                                                .darker(by: savingUsername ? 10 : 0)!)
                            )
                            .cornerRadius(25.0)
                    }
                }
                
                Text(usernameErrorMessage)
                    .italic()
                    .foregroundColor(.red)
                    .font(.system(size: 10))
            }.padding(.bottom, 30)

            Button(action: {
                self.showPasswordChange = true
            }) {
                Text("Reset Password")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .padding(.horizontal, 30)
            }.sheet(isPresented: self.$showPasswordChange) {
                PasswordChangeView()
            }.padding(.bottom, 60)
            
            Button(action: self.onSignOut) {
                Text("Sign Out")
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            VStack {
                if uploadingImage {
                    Group {
                        ProgressView().padding(.bottom, 20)
                        Text("Uploading image...")
                    }
                }
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 35)
        .background(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255))
        .navigationBarTitle("Profile", displayMode: .inline)
        .navigationBarHidden(uploadingImage)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear(perform: self.onLoaded)
    }
}

struct ProfileView_Previews: PreviewProvider {
    private static func authed(vm: AuthViewModel) -> AuthViewModel {
        vm.isAuthed = true
        
        return vm
    }
    
    private static func loggedIn(vm: UserViewModel) -> UserViewModel {
        vm.userProfile = UserProfile(username: "Greg", email: "Email", profileImage: "")
        
        return vm
    }
    
    static var previews: some View {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let authViewModel = AuthViewModel(functions: appDelegate.functions, auth: appDelegate.auth)
        
        let userViewModel = UserViewModel(
            firestore: appDelegate.firestore,
            functions: appDelegate.functions,
            auth: appDelegate.auth,
            storage: appDelegate.storage
        )
        
        ProfileView()
            .environmentObject(
                authed(vm: authViewModel)
            )
            .environmentObject(
                loggedIn(vm: userViewModel)
            )
    }
}
