# Camera-Translate-App
실시간으로 카메라에 비치는 텍스트를 인식해 번역할 수 있습니다.

> 프로젝트 기간: 2023-10-09 ~ 2023-10-17


</br>

## 📝 목차
1. [타임라인](#📆-타임라인)
2. [실행화면](#🖥️-실행-화면)
3. [다이어그램](#💎-다이어그램)
4. [트러블 슈팅](#🔥-트러블-슈팅)
5. [참고 링크](#📚-참고-링크)

</br>

# 📆 타임라인  
|**날짜**|**진행 사항**|
|:-:|-|
|2023-10-10|- TranslationView 생성|
|2023-10-13|- UIColor extension으로 색상 추가<br>- 번역 언어 교환을 위한 버튼 이미지 추가<br>- Language 타입 추가<br>- 카메라 사용을 위한 권한 요청 추가<br>- DataScannerViewController 추가<br>- PaddingLabel 타입 추가<br>- 스캔한 화면 위에 텍스트를 표시할 레이블 추가<br>- 카메라에서 줌 기능을 사용할 수 있도록 수정<br>- API Key 추가 및 은닉<br>- 파파고 API에 활용할 DTO 생성<br>- API Key를 가져오기 위한 Bundle extension 생성|
|2023-10-14|- API 사용을 위한 프로토콜 생성<br>- PapagoAPI 타입 생성<br>- HTTPMethod 타입 생성<br>- NetworkError 타입 생성<br>- NetworkManager 타입 생성<br>- 텍스트 인식 후 화면에 번역 결과를 표시하는 기능 추가|
|2023-10-15|- UIColor extension에 색상 추가<br>- LanguageType 생성<br>- 소스 언어와 타겟 언어를 뒤바꾸는 기능 구현<br>- TranslationModel 생성<br>- TranslationViewModel 생성<br>- TranslationModel과 TranslationViewModel 데이터 바인딩|
|2023-10-16|- AlertBuilder 생성<br>- 카메라 권한이 없을 때 요청하는 얼럿 추가|



</br>

# 🖥️ 실행 화면
<img src="https://github.com/hojun-jo/Camera-Translate-App/assets/86751964/8670fedc-7b8f-403b-8be0-98a8997aa79b">



</br>

# 💎 다이어그램



</br>

# 🔥 트러블 슈팅
## 1️⃣ UIImageView에 GestureRecognizer 추가

### 🔍 문제점
이미지 뷰를 버튼처럼 사용하기 위해 UITapGestureRecognizer를 추가했지만 인식이 안 되는 문제가 발생 했습니다.
```swift
final class TranslationView: UIView {
...
    private let pauseImageView: UIImageView = {
        let imageView = UIImageView()
        ...
        
        return imageView
    }()
...
    private func setUpActions() {
        ...
        pauseImageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(didTappedPauseImageView)))
    }
...
}
```


### ⚒️ 해결방안
원인은 아래와 같습니다.
- 이미지 뷰의 isUserInteractionEnabled은 false가 기본값
- 이미지 뷰는 기본적으로 사용자 이벤트를 무시
- 일반적으로 이미지 뷰는 인터페이스에 시각적 콘텐츠를 표시하는 데에만 사용

따라서 이미지 뷰의 isUserInteractionEnabled을 true로 설정하여 입력을 받을 수 있도록 했습니다.
```swift
private let pauseImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "pause.circle")
    imageView.tintColor = .black
    imageView.layer.cornerRadius = 50
    imageView.layer.backgroundColor = UIColor.white.cgColor
    imageView.isUserInteractionEnabled = true
    
    return imageView
}()
```
<!-- 
## 2️⃣ 

### 🔍 문제점


### ⚒️ 해결방안



## 3️⃣ 

### 🔍 문제점


### ⚒️ 해결방안


## 4️⃣ 

### 🔍 문제점


### ⚒️ 해결방안
 -->


</br>

# 📚 참고 링크

* [🍎 Apple Docs - UIImageView](https://developer.apple.com/documentation/uikit/uiimageview#1807299)
* [🍎 Apple Docs - isUserInteractionEnabled](https://developer.apple.com/documentation/uikit/uiview/1622577-isuserinteractionenabled)
<!-- * [🍎 Apple Docs - ]()
* [🍎 Apple Docs - ]()
* [🌐 stackoverflow - ]() -->

</br>
