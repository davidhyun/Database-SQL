# Normalization(정규화)

- 데이터베이스의 테이블이 잘 만들어졌는지 평가하고, 잘 만들지 못한 테이블을 고쳐나가는 과정
- 테이블을 **정규형(Normal Form)**이라고 불리는 형태에 부합하게 만들어나감

- 데이터베이스에서 **이상현상(Anomaly)**을 없앨 수 있다.
- 새로운 종류의 데이터를 추가할 때 테이블 구조 수정을 많이 하지 않아도 된다.
- 데이터베이스 구조를 단순화해서 사용자가 더 쉽게 이해할 수 있다.
- 데이터 모델을 만들고, 데이터베이스에 **구현하기 전에** 적용하면 좋다.

<br/>

## Anomaly(이상 현상)

- 데이터베이스에서 삽입, 업데이트, 삭제를 제대로 할 수 없게 되는 경우
- 데이터 모델링이 제대로 되지 않았기 때문에 발생(테이블과 컬럼이 제대로 나눠지지 않았기 때문)

| 삽입 이상                                                    | 업데이트 이상                                                | 삭제 이상                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 새로운 데이터를 자연스럽게 저장할 수 없는 경우<br />(회사정보만 삽입하고 싶을 때) | 데이터를 업데이트했을 때, 정확성을 지키기 어려워지는 경우<br />(회사 전화번호를 일일이 바꿔줘야할 때) | 원하는 데이터만 자연스럽게 삭제할 수 없는 경우<br />(회사정보는 지우고 싶지 않을 때) |
| <img src="https://user-images.githubusercontent.com/64063767/116424748-bde14400-a87c-11eb-9841-68dc7a7cbbbe.png" alt="image" style="zoom:50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/116425036-f719b400-a87c-11eb-82a5-7654171c7793.png" alt="image" style="zoom:50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/116425384-3811c880-a87d-11eb-98c8-2c12deb6b7bb.png" alt="image" style="zoom:50%;" /> |

<br/>

## Normal Form(정규형)

- 1NF, 2NF, 3NF, ..., (EKNF, BCNF, 4NF, ETNF, 5NF, DKNF, 6NF)

- 순서에 따라 규칙이 누적된다

  <img src="https://user-images.githubusercontent.com/64063767/116708810-0890c680-aa0b-11eb-9b23-22c770f0c675.png" alt="image" style="zoom: 50%;" />

<br/>

### (1) 1NF

- 테이블 안 모든 row의 모든 column 값들은 나눌 수 없는 **단일 값**이어야 한다.

- 조회하거나 수정이 복잡해질 수 있기 때문에 하나의 컬럼에 여러값을 두지 않는다.

1. 하나의 컬럼에 같은 종류의 값을 여러개 저장하고 있을 때

   : 해당 컬럼을 하나의 테이블로 분리해서 모델링한다. (전화번호테이블 - ForeignKey : user_id)

2. 하나의 컬럼에 서로 다른 종류의 값을 여러개 저장하고 있을 때

   : 하나의 컬럼을 여러개로 분리해서 모델링한다. (full name -> first_name, middle_name, last_name)

<br/>

### Functional Dependency(함수 종속성)

테이블 안 Attribute들 사이에서 생기는 관계로 X의 값에 따라서 Y의 값이 결정될 때 Y는 X에 함수 종속성이 있다고 한다.

- x -> y

  | email -> {name, age, gender}                                 | {user, product} -> score                                     |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | <img src="https://user-images.githubusercontent.com/64063767/116711734-1b58ca80-aa0e-11eb-9705-404a4b6c1554.png" alt="image" style="zoom:50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/116712119-7d193480-aa0e-11eb-8eb7-36ca6e16f2b5.png" alt="image" style="zoom:50%;" /> |

- x -> y-> z (이행성)

  product -> brand -> brand_country

  <img src="https://user-images.githubusercontent.com/64063767/116712940-4e4f8e00-aa0f-11eb-9dae-cd16d8250e8e.png" alt="image" style="zoom:50%;" />

<br/>

### (2) 2NF