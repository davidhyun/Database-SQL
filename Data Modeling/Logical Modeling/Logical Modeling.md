# Logical Modeling(논리적 모델링)

- 모델링의 시작은 저장하고 싶은 데이터의 **Entity**, **Attribute**, **Relationship** 파악으로부터 시작한다.

- 이는 해당 서비스의 **비즈니스 룰(사업규칙)**을 이용하면 된다.

  > Business Rule : 특정 조직이 운영되기 위해 따라야 하는 정책, 절차, 원칙들에 대해 간단명료하면서도 필요한 내용을 모두 담고 있는 사업규칙 (웹사이트의 경우, 페이지에서 제공하는 모든 기능에 관한 규칙)

<br/>

## ERM 초안 작성하기

- 비즈니스 룰에서 <span style="color:blue;">Entity</span>, <span style="color:green;">Attribute</span>, <span style="color:orange;">Relationship</span> 후보 찾기

  - 모든 <span style="color:blue;">명사</span>는 <span style="color:blue;">Entity</span> 후보다.

  - 모든 <span style="color:orange;">동사</span>는 <span style="color:orange;">Relationship</span> 후보다.

  - <span style="color:green;">하나의 값으로 표현할 수 있는 명사</span>는 <span style="color:green;">Attribute</span> 후보다.

    - 예외 : 값으로 표현할 수 있는 명사여도 Entity로 표현하는 경우로 Entitiy 안에 똑같은 종류의 여러 Attribute를 저장해야할 때 Entitiy로 만든다.

      1. NULL이 많이 생길 수 있다.
      2. 컬럼을 몇 개를 만들어야되는지 애매해진다.
      3. 조회가 비효율적이게 된다.

      <img src="https://user-images.githubusercontent.com/64063767/115416963-30c23d80-a233-11eb-9ebd-dc1fc9ec0ae7.png" alt="image" style="zoom:25%;" /><img src="https://user-images.githubusercontent.com/64063767/115417558-adedb280-a233-11eb-9412-0d80be8e1b80.png" alt="image" style="zoom:25%;" />

- 온라인 쇼핑몰의 비즈니스 룰
  - <span style="color:blue;">유저</span>는 <span style="color:blue;">상품</span>을 <span style="color:orange;">주문</span>할 수 있다.
  - 동일한 <span style="color:blue;">주문 내역</span>은 한 번의 배달로, 3일 안에 <span style="color:blue;">유저</span>가 지정한 <span style="color:green;">배송지</span>에 전달돼야 한다. 
    만약 그렇지 못할 시, 유저에게 최대한 빨리 알려줘야 한다.
  - <span style="color:blue;">유저</span>는 <span style="color:blue;">상품</span>에 대한 <span style="color:blue;">평가</span>를 <span style="color:orange;">줄</span> 수 있다.
    <span style="color:blue;">평가</span>는 두 종류의 데이터 : 1~5 사이 자연수의 <span style="color:green;">별점</span>, 그리고 200자 이내 <span style="color:green;">줄 글</span>을 통해 할 수 있다.

<img src="https://user-images.githubusercontent.com/64063767/115408342-bd68fd80-a22b-11eb-9e8c-080dc9e097d6.png" alt="image" style="zoom: 25%;" />