//
//  MockData.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

struct MockData {
    let storyList: [StoryPost] = [
        StoryPost(
            id: "abcd",
            userID: "abcd1234",
            nickname: "고래밥",
            title: "오늘은...",
            content: "안녕하세요",
            imageList: ["98769876", "1230382", "123093012"],
            commentList: ["5678"],
            location: "서울 영등포구 문래동",
            isLiked: true,
            isSavedToMyCollection: false,
            createdAt: "2023-02-02",
            storyType: .advertisement
        ),
        StoryPost(
            id: "efgh",
            userID: "5678",
            nickname: "바밤바",
            title: "이탈리아",
            content: "Ciao",
            imageList: ["12341234", "21383123", "21301239"],
            commentList: ["76547654"],
            location: "서울 마포구 공덕동",
            isLiked: true,
            isSavedToMyCollection: false,
            createdAt: "2023-02-02",
            storyType: .location
        ),
        StoryPost(
            id: "ijkl",
            userID: "9638",
            nickname: "쿠앤크",
            title: "스페인",
            content: "Hola",
            imageList: ["12341234", "23123092", "120391230923", "123213231"],
            commentList: ["76547654"],
            location: "부산 해운대구 우동",
            isLiked: true,
            isSavedToMyCollection: false,
            createdAt: "2023-02-02",
            storyType: .advertisement
        )
    ]
}
