# Memento Mori
> 새싹 iOS LSLP (Light Server Level Project)
- 프로젝트 관련 기술 블로그 작성
  - [Swift x Protocol) 프로토콜과 의존성 주입, 의존성 분리 원칙 (feat. DI & DIP)](https://andy-archive.tistory.com/170)
  - [LSLP) MVVM x Input-Output x RxSwift로 이메일 검증 네트워크 요청하기 (feat. withLatestFrom & flatMap)](https://andy-archive.tistory.com/158)
  - [LSLP) MVVM과 RxSwift를 이용한 반응형 이메일 입력 화면 구현 (feat: Input-Output & BehaviorRelay)](https://andy-archive.tistory.com/156)
## I. 구조
### (1) 디렉토리 트리 구조 (Directory Structure)
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

### (2) 코디네이터 트리 구조 (Coordinator Structure)
```
📦 AppCoordinator # by SceneDelegate
├──📱 SplashViewController # (0) 자동 로그인 여부 판단
├──📂 SigninModal # (1) 토큰 만료 시 모달 화면 띄우기 
│   ├──📱 AutoSigninViewController # 자동 로그인
│   ├──📱 UserSigninViewController # 다른 유저로 로그인 
│   └──📱 UserJoinViewController # 회원가입
└──📂 TabBarCoordinator # (2) 자동 로그인/일반 로그인 성공 시 전환
    ├──📂 StoryContentCoordinator # 게시글 조회
    └──📂 StoryUploadCoordinator # 게시글 작성
```

### (3) 클린 아키텍처 구조 (MVVM-C x Clean Architecture)
- [기술 블로그 링크](https://andy-archive.tistory.com/177)
<img width="1417" alt="MVVM-C x Clean Architecture 구조" src="https://github.com/andy-archive/MementoMori/assets/102043891/f8b80437-d6a8-4347-8163-63d206983c55">

## II. 구현 화면
### (1) 로그인/회원 가입

| 종류 | [#10 로그인 화면](https://github.com/andy-archive/mementoMori/pull/10) | [#6 회원 가입 필수/선택 사항](https://github.com/andy-archive/MementoMori/pull/6) | [#5 회원 가입 이메일 검증](https://github.com/andy-archive/MementoMori/pull/5) |
|:-:|:-:|:-:|:-:|
| GIF | <img src="https://github.com/andy-archive/MementoMori/assets/102043891/fbd862fc-2602-4685-acc4-f35a96247c71" alt="#10 로그인 화면" width=200> | <img src="https://github.com/andy-archive/MementoMori/assets/102043891/a955068c-ce19-4f45-9e6f-47e859328b7e" alt="LSLP #6 회원가입 화면의 필수 및 선택 입력 사항 UI 및 로직 추가" width=200> | <img src="https://github.com/andy-archive/MementoMori/assets/102043891/a5053eb2-6243-43a9-aecc-476bf83e9d36" alt="#5 이메일 검증 응답 메시지에 따른 반응형" width=200> |

### (2) 스토리(컨텐츠) 목록 화면

| 종류 | [#25 컨텐츠 조회 API (GET)](https://github.com/andy-archive/MementoMori/pull/25) | [#16 컨텐츠 목록 화면 UI](https://github.com/andy-archive/mementoMori/pull/16) |
|:-:|:-:|:-:|
| GIF | <img src="https://github.com/andy-archive/MementoMori/assets/102043891/97dc7803-08bf-4364-9cea-eb7f3319efb6" alt="LSLP #25 컨텐츠 조회 API (GET)" width=200> |<img src="https://github.com/andy-archive/MementoMori/assets/102043891/393bce40-39d0-496f-a541-db0f058cc0b7" alt="이미지" width=200> |

## III. 트러블 슈팅
### (1) 이미지에 대한 캐싱 및 다운샘플링 구현
#### 배경 및 이유 
##### 이미지에 대한 네트워크 요청 시 비용 증가
1. 원본 이미지 렌더링 시 시 CPU/GPU 소모 비용 
2. 네트워크 요청 비용
#### PR / Issue 링크
| 종류 | PR / Issue | 링크 |
|:-:|:-:|:-:|
| 문제 해결 | Pull Requests | [#25 이미지 업로드 시 캐싱 및 다운샘플링 구현](https://github.com/andy-archive/MementoMori/pull/25) |

### (2) 토큰 매니저 (키 값이 동일한 문제)
#### 배경 및 이유
##### 다른 유저 로그인 시 기존 유저의 토큰 갱신
- 매번 토큰이 각각 같은 키 값(accessToken, refreshToken)으로 저장이 되어
- 기존 유저가 아닌 다른 유저가 로그인 시
- 새로운 유저의 토큰 생성이 아닌 기존 유저의 토큰이 갱신되는 문제 발생 및 해결
##### PR / Issue 링크
| 종류 | PR / Issue | 링크 |
|:-:|:-:|:-:|
| 기존 코드 | Pull Requests | [#12 키체인/토큰 매니저 생성 및 로그인 성공 시 토큰을 키체인 저장 (+ 에러 핸들링))](https://github.com/andy-archive/MementoMori/pull/12) |
| 문제 발생 | Issues | [#13 토큰 매니저로 저장 시 같은 값으로 저장되는 문제 발생 (→ id 값 추가)](https://github.com/andy-archive/MementoMori/issues/13) |
| 문제 해결 | Pull Requests | [#14 키체인 매니저에서 id를 포함한 토큰 값 저장 (+ refresh API 구조 생성)](https://github.com/andy-archive/MementoMori/pull/14) |
> id를 포함한 accessToken, refreshToken을 각각 저장
<img width="532" alt="LSLP #13 id를 포함한 토큰 저 KeychainRepository" src="https://github.com/andy-archive/MementoMori/assets/102043891/4c82b01b-d65c-4c09-9b52-79a8a26052e4">

## IV. MVVM-C x 클린 아키텍처 적용
- [#9 MVVM에서 클린 아키텍처 구조(+ Coordinator)로 변경](https://github.com/andy-archive/MementoMori/pull/9)
### (0) 도입 배경
<img width="1417" alt="MVVM-C x Clean Architecture 도입 배경" src="https://github.com/andy-archive/MementoMori/assets/102043891/3e8b5208-1eaa-4874-9b0c-bbaf39f49764">

- (문제점) MVVM을 도입한 이후 비즈니스의 로직이 점차 증가하여 로직을 분리할 필요성을 느낌
  - (1) ViewModel의 역할의 증가
    - 화면 전환 로직, 비즈니스 로직의 공존
  - (2) 의존성 문제 발생
    - VC는 VM에, VM은 Network에 의존하게 됨
- (해결책)
  - (1) Cooridnator 패턴을 도입하여 ViewModel의 화면 전환 로직을 분리하였습니다.
  - (2) UseCase를 활용하여 VM의 자세한 비즈니스 로직을 분리하였습니다.
- (특이 사항) UseCase에 대한 사용이 익숙하지 않아 UseCase의 역할이 부족해 보입니다.
  - 실제 적용을 거듭하며 UseCase의 로직을 개선해야 할 것 같습니다.

### (1) 적용 후 변화
#### (1-1) ViewModel의 역할 분리
<img width="1417" alt="MVVM-C x Clean Architecture 도입 후 변화 1 - ViewModel의 역할 분리" src="https://github.com/andy-archive/MementoMori/assets/102043891/11f61f72-6f82-44a5-8d3f-34acb5786c89">

#### (1-2) 의존성 주입(DI; Dependency Injection)
<img width="1415" alt="MVVM-C x Clean Architecture 도입 후 변화 2 - DI" src="https://github.com/andy-archive/MementoMori/assets/102043891/da3a8a6d-8fa5-4dc8-8952-fa6cffc38e25">

- VC/VM/UseCase의 인스턴스를 외부(Coordinator)에 생성
- 각 계층의 클래스에 다른 계층의 프로토콜만을 프로퍼티로 정의
  - 의존성을 줄이고 응집도를 높이도록 했습니다.
  - 예시
    - [#11 키체인/토큰 매니저 생성](https://github.com/andy-archive/mementoMori/pull/12)

#### (1-3) 의존성 역전 원칙(DIP; Dependency Inversion Principle)
<img width="1415" alt="MVVM-C x Clean Architecture 도입 후 변화 3 - DIP" src="https://github.com/andy-archive/MementoMori/assets/102043891/9032055f-8cb5-4ad1-aeb3-8c45ad52b6b1">

- (이전) VC → VM → UseCase → Repository (일방향 의존성)
- (이후) VC → VM → UseCase 🔙 Repository Protocol → Repository (의존성 <u>역전</u>)

### (2) 클린 아키텍처 적용
#### 의존성 주입
### (3) 코드 예시
#### [#11 토큰 매니저 생성](https://github.com/andy-archive/mementoMori/pull/12)
##### (3-1) 키체인 프로토콜 정의
- `MementoMori/Sources/Data/DataSources/Local/KeychainManager.swift`
```Swift
protocol KeychainManager {
    //...
}
```
##### (3-2) 토큰 매니저 클래스 생성 및 프로토콜 채택
- `MementoMori/Sources/Data/Repositories/Local/TokenManager.swift`
```Swift
final class TokenManager: KeychainManager {
```

##### (3-3) 토큰 매니저를 UseCase에 사용 및 비즈니스 로직 구현
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

##### (3-4) UseCase의 로직 결과를 ViewModel로 전달 및 Coordinator 화면 전환 여부 판단
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

##### (3-5) Coordinator에서 의존성 주입
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
