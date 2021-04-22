# Logical Modeling(논리적 모델링)

- 모델링의 시작은 저장하고 싶은 데이터의 **Entity**, **Attribute**, **Relationship** 파악으로부터 시작한다.

- 이는 해당 서비스의 **비즈니스 룰(사업규칙)**을 이용하면 된다.

  > Business Rule : 특정 조직이 운영되기 위해 따라야 하는 정책, 절차, 원칙들에 대해 간단명료하면서도 필요한 내용을 모두 담고 있는 사업규칙 (웹사이트의 경우, 페이지에서 제공하는 모든 기능에 관한 규칙)
  
- Business Rule을 파악하여 ERM을 만들어냈던 것처럼, 반대로 ERM을 통해서 Business Rule을 역으로 파악할 수도 있다.

<br/>

## ERM(ERD) 초안 작성하기

- 비즈니스 룰에서 <span style="color:blue;">Entity</span>, <span style="color:green;">Attribute</span>, <span style="color:orange;">Relationship</span> 후보 찾기

  - 모든 <span style="color:blue;">명사</span>는 <span style="color:blue;">Entity</span> 후보다.

  - 모든 <span style="color:orange;">동사</span>는 <span style="color:orange;">Relationship</span> 후보다.

  - <span style="color:green;">하나의 값으로 표현할 수 있는 명사</span>는 <span style="color:green;">Attribute</span> 후보다.

    - 예외1 : M:N (다대다) 관계에서는 동사도 Entity 후보가 될 수 있다.

    - 예외2 : 값으로 표현할 수 있는 명사여도 Entity로 표현하는 경우로 Entitiy 안에 똑같은 종류의 여러 Attribute를 저장해야할 때 Entitiy로 만든다.

      1. NULL이 많이 생길 수 있다.
      2. 컬럼을 몇 개를 만들어야되는지 애매해진다.
      3. 조회가 비효율적이게 된다.

      <img src="https://user-images.githubusercontent.com/64063767/115416963-30c23d80-a233-11eb-9ebd-dc1fc9ec0ae7.png" alt="image" style="zoom:25%;" /><img src="https://user-images.githubusercontent.com/64063767/115417558-adedb280-a233-11eb-9412-0d80be8e1b80.png" alt="image" style="zoom:25%;" />

<br/>

- 온라인 쇼핑몰의 비즈니스 룰
  - <span style="color:blue;">유저</span>는 <span style="color:blue;">상품</span>을 <span style="color:orange;">주문</span>할 수 있다.
  - 동일한 <span style="color:blue;">주문 내역</span>은 한 번의 배달로, 3일 안에 <span style="color:blue;">유저</span>가 지정한 <span style="color:green;">배송지</span>에 전달돼야 한다. 
    만약 그렇지 못할 시, 유저에게 최대한 빨리 알려줘야 한다.
  - <span style="color:blue;">유저</span>는 <span style="color:blue;">상품</span>에 대한 <span style="color:blue;">평가</span>를 <span style="color:orange;">줄</span> 수 있다.
    <span style="color:blue;">평가</span>는 두 종류의 데이터 : 1~5 사이 자연수의 <span style="color:green;">별점</span>, 그리고 200자 이내 <span style="color:green;">줄 글</span>을 통해 할 수 있다.

<img src="https://user-images.githubusercontent.com/64063767/115408342-bd68fd80-a22b-11eb-9e8c-080dc9e097d6.png" alt="image" style="zoom: 25%;" />

<br/>

## 카디널리티(Cardinality)

카디널리티(Cardinality)는 Entity type A와 Entity type B 사이에서  A Entity 한 개가 B Entity 몇 개와 연결될 수 있는지, 반대로 B Entity 한 개가 A Entity 몇 개와 연결될 수 있는지 나타내는 개념이다.

비즈니스 룰을 제대로 이해해서 카디널리티를 파악해야한다. 

왜냐하면 어떤 관계가 있는지에 따라 모델링이 바뀔 수 있기 때문이다.

| 1:1 (일대일)                                                 | 1:N (일대다)                                                 | M:N (다대다)                                                 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/64063767/115724352-d6081d80-a3bb-11eb-959a-b4fd403c20c9.png" alt="image" style="zoom: 50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/115724578-094aac80-a3bc-11eb-896f-6be7c7749386.png" alt="image" style="zoom: 50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/115724717-2aab9880-a3bc-11eb-8e35-ba73b48ae305.png" alt="image" style="zoom: 50%;" /> |

<br/>

## 카디널리티를 ERM(ERD)에서 나타내기(Crow's foot 표현법)

### (1) 최대 카디널리티

한 개의 Entity가 다른 Entity와 최대 몇 개 까지 연결될 수 있는지에 대한 내용

| 1:1 (일대일)                                                 | 1:N (일대다)                                                 | M:N (다대다)                                                 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/64063767/115725537-e79df500-a3bc-11eb-96ab-e3e89be6f2e0.png" alt="image" style="zoom: 50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/115725746-14eaa300-a3bd-11eb-85f3-93d905f9eb55.png" alt="image" style="zoom:50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/115725804-20d66500-a3bd-11eb-91e3-3916cad3f9bf.png" alt="image" style="zoom:50%;" /> |

<br/>

### (2) 최소 카디널리티

한개의 Entity가 다른 Entity와 최소 몇 개까지 연결될 수 있는지에 대한 내용

|                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/64063767/115727049-38fab400-a3be-11eb-8049-75b8bf8f6e71.png" alt="image" style="zoom:50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/115727487-9989f100-a3be-11eb-8ac3-599871f80fa7.png" alt="image" style="zoom:50%;" /> |

<br/>

### (3) 최소 카디널리티와 최대 카디널리티의 결합

<img src="https://user-images.githubusercontent.com/64063767/115727714-d35af780-a3be-11eb-983e-72fd827680f7.png" alt="image" style="zoom:50%;" />

<br/>

## 일대일, 일대다 관계 모델링

### (1) 일대일 관계 모델링

유저가 무조건 카드가 있어야만 할 때는 유저 테이블에 Foreign Key를 넣어도 되지만, 카드가 없어도 된다면 불필요한 NULL 값을 방지하기 위해 유저 테이블이 아닌 카드 테이블에 Foreign Key를 설정한다.

<img src="https://user-images.githubusercontent.com/64063767/115729689-97289680-a3c0-11eb-952a-8df7d9eac7fd.png" alt="image" style="zoom:50%;" />

<img src="https://user-images.githubusercontent.com/64063767/115729335-4dd84700-a3c0-11eb-811f-14cea5ac49d1.png" alt="image" style="zoom:50%;" />

<img src="https://user-images.githubusercontent.com/64063767/115729266-3dc06780-a3c0-11eb-8ddd-644b1deaf3c4.png" alt="image" style="zoom:50%;" />

<br/>

### (2) 일대다 관계 모델링

Entity와 Entity 사이에 1:N (일대다) 관계가 있을 때는 **항상 다수 쪽에 해당하는 Entity에 Foreign Key를 설정**한다.

<img src="https://user-images.githubusercontent.com/64063767/115730336-2e8de980-a3c1-11eb-8fca-48f524029420.png" alt="image" style="zoom:50%;" />

<img src="https://user-images.githubusercontent.com/64063767/115730484-4d8c7b80-a3c1-11eb-9e3d-44842ca967ab.png" alt="image" style="zoom:50%;" />

<img src="https://user-images.githubusercontent.com/64063767/115730682-7c0a5680-a3c1-11eb-8c08-b2c2f7fa6458.png" alt="image" style="zoom:50%;" />

<br/>

### (3) 다대다 관계 모델링

다대다 관계에 있는 두 Entity는 테이블 두개만으로는 자연스럽게 표현할 수 없다.

다대다 관계에 있는 두 Entity는 **새로운 Entity + 두 개의 일대다 관계로 모델링**한다.

여기서 새로운 Entity를 연결 테이블(Junction Table)이라고 한다.

<img src="https://user-images.githubusercontent.com/64063767/115731921-7c572180-a3c2-11eb-9324-cb01d6f74e7f.png" alt="image" style="zoom:50%;" />

<img src="https://user-images.githubusercontent.com/64063767/115732119-a872a280-a3c2-11eb-9d35-038ac2f313f5.png" alt="image" style="zoom:50%;" />

<img src="https://user-images.githubusercontent.com/64063767/115731758-5af63580-a3c2-11eb-96e1-9abbf414f0b4.png" alt="image" style="zoom:50%;" />