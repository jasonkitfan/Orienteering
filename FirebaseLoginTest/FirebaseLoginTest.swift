//
//  FirebaseLoginTest.swift
//  FirebaseLoginTest
//
//  Created by Kit Fan Cheung on 27/6/2023.
//

import XCTest

class FirebaseLoginTest: XCTestCase {
    let auth = FirebaseAuthManager()
    
    func testSucceedLogin(){
        auth.loginUserWithEmailAndPassword(email: "test@test.com", password: "12345678") { message, status in
            XCTAssertEqual(message, "success")
            XCTAssertEqual(status, true)

        }
    }
    
    func testFailLogin(){
        auth.loginUserWithEmailAndPassword(email: "test@test.com", password: "1234567890") { message, status in
            XCTAssertEqual(message, "fail")
            XCTAssertEqual(status, false)

        }
    }
}
