# Memento Mori

## 새싹 iOS LSLP (Light Server Level Project)

### 파일 트리 구조 (MVVM-C x Clean Architecture)
```bash
📦 MementoMori # 프로젝트 최상위 디렉토리
├──📄 README.md # 프로젝트 설명
├──📂 MementoMori
│   ├──📂 Resources
│   │   └──📂 AppInfo # Assets, LaunchScreen, Info.plist
│   ├──📂 Sources # 3개의 계층(Data, Domain, Presentation)으로 분리
│   │   ├──📂 Application
│   │   │   ├──📂 Coordinator # 전체 화면 전환 및 실제 인스턴스 생성
│   │   │   └──📂 Delegate # AppDelegate & SceneDelegate
│   │   ├──📡 Data # (1) 로컬/리모트를 활용한 데이터의 가공
│   │   │   ├──📂 DataMapping # DTO (네트워크 요청/응답에 관한 모델)
│   │   │   ├──📂 DataSources # Repositories에 사용할 메서드 및 에러 정의 
│   │   │   └──📂 Repositories # DataSources를 활용한 Domain의 Repository Protocol의 구현체
│   │   ├──📝 Domain # (2) 비즈니스 모델과 로직
│   │   │   ├──📂 RepositoryProtocol # Data의 Repositories에 관한 프로토콜 (의존성 역전)
│   │   │   ├──📂 Entities # 비즈니스 모델
│   │   │   └──📂 UseCases # 비즈니스 로직
│   │   └──📱 Presentation # (3) 실제 보여지는 개별 화면의 로직
│   │       ├──📚 ViewController # 개별 화면 표시와 이벤트 송·수신
│   │       ├──📚 ViewModel # 개별 화면에서 발생한 이벤트의 입력 값을 가공하여 출력 값을 전달
│   │       └──📚 Coordinator # 개별 화면의 전환 및 실제 인스턴스의 생성
│   └──📂 Utilities
│       ├──📂 Constants
│       └──📂 Extensions
└──📂 MementoMori.xcodeproj
```

## 구현 화면
### 로그인/회원 가입

| 종류 | [#10 로그인 화면](https://github.com/andy-archive/mementoMori/pull/10) | [#6 회원 가입 필수/선택 사항](https://github.com/andy-archive/MementoMori/pull/6) | [#5 회원 가입 이메일 검증](https://github.com/andy-archive/MementoMori/pull/5) |
|-|-|-|-|
| | <img src="https://github.com/andy-archive/MementoMori/assets/102043891/fbd862fc-2602-4685-acc4-f35a96247c71" alt="이미지" width=200> | <img src="https://github.com/andy-archive/MementoMori/assets/102043891/a955068c-ce19-4f45-9e6f-47e859328b7e" alt="LSLP #6 회원가입 화면의 필수 및 선택 입력 사항 UI 및 로직 추가" width=200> | <img src="https://github.com/andy-archive/MementoMori/assets/102043891/a5053eb2-6243-43a9-aecc-476bf83e9d36" alt="#5 이메일 검증 응답 메시지에 따른 반응형" width=200> |

## MVVM-C x 클린 아키텍처 적용
- [#9 MVVM에서 클린 아키텍처 구조(+ Coordinator)로 변경](https://github.com/andy-archive/MementoMori/pull/9)
### MVVM-C 적용
- (문제점) MVVM을 적용하는 중에 역할의 분리가 필요해 보였습니다.
    - ViewModel의 역할의 증가
        - 화면 전환 로직, 비즈니스 로직의 공존
    - ViewModel은 Network에 의존
- (해결책) Cooridnator 패턴을 도입하여 ViewModel의 화면 전환 로직을 분리하였습니다.
- (특이 사항) 아직은 UseCase에 대한 사용이 익숙하지 않아 UseCase의 역할이 부족해 보입니다. 다른 여러 프로젝트를 보면서 UseCase의 로직을 개선해야 할 것 같습니다. 
### 클린 아키텍처 적용
#### 의존성 주입
- ViewController/ViewModel/UseCase 등과 같은 인스턴스를 외부(Coordinator)에 생성했습니다.
- 각 계층의 클래스에 다른 계층의 프로토콜만을 프로퍼티로 정의하여, 의존성을 줄이고 응집도를 높이도록 했습니다.
  - 예시 [#11 키체인/토큰 매니저 생성](https://github.com/andy-archive/mementoMori/pull/12) 

## 기능
### [#11 토큰 매니저 생성](https://github.com/andy-archive/mementoMori/pull/12)
#### 1-1) 키체인 프로토콜 정의
- `MementoMori/Sources/Data/DataSources/Local/KeychainManager.swift`
```Swift
protocol KeychainManager {
    //...
}
```
#### 1-2) 토큰 매니저 클래스 생성 및 프로토콜 채택
- `MementoMori/Sources/Data/Repositories/Local/TokenManager.swift`
```Swift
final class TokenManager: KeychainManager {
```

#### 1-3) 토큰 매니저를 UseCase에 사용 및 비즈니스 로직 구현
- `MementoMori/Sources/Domain/UseCases/UserAuth/UserSigninUseCase.swift`
```Swift
final class UserSigninUseCase: UserSigninUseCaseProtocol {
    private let keychainManager: KeychainManager
    
    init(
        keychainManager: KeychainManager
    ) {
        self.keychainManager = keychainManager
    }
```

#### 1-4) UseCase의 로직 결과를 ViewModel로 전달 및 Coordinator 화면 전환 여부 판단
```Swift
final class UserSigninViewModel: ViewModel {

    weak var coordinator: AppCoordinator?
    let disposeBag = DisposeBag()
    private let userSigninUseCase: UserSigninUseCaseProtocol
    
    func transform(input: Input) -> Output {
    //...
        input
            //...
            .flatMap { user in
                self.userSigninUseCase.signin(user: user)
            }
            .bind(with: self) { owner, result in
                let signinProcess = self.userSigninUseCase.verifySigninProcess(response: result)
                if signinProcess.isCompleted {
                    self.coordinator?.showTabBarFlow()
    //...
```

#### 1-5) Coordinator에서 의존성 주입
- `MementoMori/Sources/Application/Coordinator/AppCoordinator.swift`
```Swift
extension AppCoordinator {
    private func showUserSignViewController() {
        let viewController = UserSigninViewController(
            viewModel: UserSigninViewModel(
                coordinator: self,
                userSigninUseCase: UserSigninUseCase(
                    userAuthRepository: makeAuthRepository(),
                    keychainManager: TokenManager()
                )
            )
        )
        //...
```
