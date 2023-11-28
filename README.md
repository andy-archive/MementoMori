# Memento Mori

## 새싹 iOS LSLP (Light Server Level Project)

### 파일 트리 구조
```bash
📦 MementoMori
├──📄 README.md
├──📂 MementoMori
│   ├──📂 Resources
│   │   └──📂 AppInfo # Assets, LaunchScreen, Info.plist
│   ├──📂 Sources
│   │   ├──📂 Application  # AppDelegate & SceneDelegate
│   │   ├──📂 Data
│   │   │   ├── DataMapping # DTO (요청, 응답에 대한 모델)
│   │   │   ├── DataSources # 로컬, 리모트에 대한 메서드
│   │   │   ├── Network # API, Error, request 메서드
│   │   │   └── Repositories # Domain Repositories의 구현체 & DTO 요청-응답을 Entities로 변환
│   │   ├──📂 Domain
│   │   │   ├── Entities # 비즈니스 모델
│   │   │   ├── Repositories # 프로토콜
│   │   │   └── UseCases # 비즈니스 로직
│   │   └──📂 Presentation # ViewController, ViewModel, Coordinator
│   └──📂 Utilities
│       ├──📂 Constants
│       └──📂 Extensions
└──📂 MementoMori.xcodeproj
```

### 회원 가입 화면

| 종류 | [#6 필수 및 선택 사항 UI 추가](https://github.com/andy-archive/MementoMori/pull/6) | [#5 이메일 검증 반응형](https://github.com/andy-archive/MementoMori/pull/5) |
|-|-|-|
| | <img src="https://github.com/andy-archive/MementoMori/assets/102043891/a955068c-ce19-4f45-9e6f-47e859328b7e" alt="LSLP #6 회원가입 화면의 필수 및 선택 입력 사항 UI 및 로직 추가" width=200> | <img src="https://github.com/andy-archive/MementoMori/assets/102043891/a5053eb2-6243-43a9-aecc-476bf83e9d36" alt="#5 이메일 검증 응답 메시지에 따른 반응형" width=200> |

## MVVM-C x 클린 아키텍처
### MVVM-C
- (문제점) MVVM을 적용하는 중에 역할의 분리가 필요해 보였습니다.
    - ViewModel의 역할의 증가
        - 화면 전환 로직, 비즈니스 로직의 공존
    - ViewModel은 Network에 의존
- (해결책) Cooridnator 패턴을 도입하여 ViewModel의 화면 전환 로직을 분리하였습니다.

### 클린 아키텍처
#### 의존성 주입
- 프로토콜을 이용한 의존성 주입으로, 각 계층의 클래스에 다른 계층의 프로토콜만을 채택하여 해당 계층에 대한 의존성을 줄였습니다. 
