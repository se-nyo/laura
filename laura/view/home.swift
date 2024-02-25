//
//  Home.swift
//  laura
//
//  Created by senyo on 2/24/24.
//

import SwiftUI



struct Home: View {
   
//    print(key)
    func getKey(){
        let key = userDefaults.object(forKey: "userKey") as? String
        print(key)
    }
    
//    getKey()

    var body: some View {
//        Text("Hello, World!\(key)")
        Text("WHYYY")
    }
}

#Preview {
    Home()
}
