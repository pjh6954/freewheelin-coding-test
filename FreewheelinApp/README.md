# Storyboard
* 구현 내용 : 
  - Save버튼을 통해 Realm 저장 및 photo library에 snapshot저장. Background이미지가 있는 경우 별도로 저장을 시키기 때문에 나중에 load에서도 background image를 이용함.
  - Load버튼을 통해 새로운 Controller에서 이전에 저장한 그림을 불러 올 수 있음(draw object포함). Background이미지(Add버튼을 통해서 불러온 경우) 마찬가지로 별도로 불러와짐
  - ADD버튼을 통해서 Background용 이미지를 photo library에서 불러올 수 있음.
  - Undo버튼으로 그린 항목이 있다면 지울 수 있음(Erase포함)
  - Redo버튼으로 이전에 Undo 한 내용을 복구할 수 있음
  - Pen버튼으로 검정색(.black)선을 그릴 수 있음
  - Erase버튼으로 유저가 지우고 싶은 부분을 지울 수 있음.
* 미구현 내용 : 
  - 요구에 적힌대로 구현했다고 생각은 됨. 

# SwiftUI
* 구현 내용 : 
  - Undo버튼으로 그린 항목이 있다면 지울 수 있음
  - Redo버튼으로 이전에 Undo 한 내용을 복구할 수 있음
  - Pen 버튼을 누르지 않아도 기본적으로 그림을 그릴 수 있는 상태
* 미구현 내용 : 
  - Save버튼을 통해 Realm 저장 및 photo library에 snapshot저장.
  - Load버튼을 통해 새로운 Controller에서 이전에 저장한 그림을 불러 올 수 있는 기능(draw object포함)
  - ADD버튼을 통해서 Background용 이미지를 photo library에서 불러올 수 있음.
  - Pen버튼으로 검정색(.black)선을 그릴 수 있음
  - Erase버튼으로 유저가 지우고 싶은 부분을 지울 수 있음.

# 참고 자료 : 
* 이전 연습이나 회사에서 구현한 내용 참고(일부 내용은 [공부용 Repositories](https://github.com/pjh6954/CodingTestPracticeDirectory)에 정리중이거나 블로그에 정리 된 내용)
* [iPad landscape, iPhone Portrait only](https://stackoverflow.com/questions/30536616/swift-allow-rotation-on-ipad-only)
* [깔끔한 UIBarButtonItem 추가](https://calmone.tistory.com/entry/iOS-UIKit-in-Swift-4-UIBarButtonItem-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0)
* [CollectionViewLayout관련 쉽게 코드로 설정하기](https://www.raywenderlich.com/18895088-uicollectionview-tutorial-getting-started)
* [CollectionViewLayout관련 코드로 설정하기(2)](https://stackoverflow.com/a/40026767/13049349)
* [SwiftUI embedin Storyboard](https://medium.com/@max.codes/use-swiftui-in-uikit-view-controllers-with-uihostingcontroller-8fe68dfc523b)


SwiftUI를 이론으로 조금씩 공부만 하고있다가 이번에 처음으로 제대로 만들어봤습니다. SwiftUI로 만들기에는 제 실력에 모자란 부분이 많아서 일단 Storyboard로 기능을 구현하고 해당 기능에 맞게 SwiftUI를 이용하여 구현하는 식으로 했습니다.
