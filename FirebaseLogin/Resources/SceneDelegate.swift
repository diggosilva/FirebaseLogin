//
//  SceneDelegate.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 02/02/25.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        // Verifique se o identificador está presente
        if isFirstLaunch() {
            // Se for a primeira execução (indica reinstalação), deslogue o usuário
            do {
                try Auth.auth().signOut()
                print("Usuário deslogado devido a reinstalação do app")
            } catch {
                print("Erro ao fazer logout: \(error.localizedDescription)")
            }
        }
        window.rootViewController = UINavigationController(rootViewController: LoginController())
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func isFirstLaunch() -> Bool {
         let defaults = UserDefaults.standard
         let isFirstLaunch = defaults.bool(forKey: "hasLaunchedBefore")
         
         if !isFirstLaunch {
             // Salvar um identificador único indicando que o app foi instalado
             defaults.set(true, forKey: "hasLaunchedBefore")
             defaults.set(UUID().uuidString, forKey: "appInstallUUID")
             defaults.synchronize()
             return true // Primeira vez, o app foi instalado
         }
         return false // O app já foi executado antes
     }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
