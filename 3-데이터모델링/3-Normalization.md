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

- **테이블 안 모든 row의 모든 column 값들은 나눌 수 없는 <span style='color:red;'>단일 값</span>이어야 한다.**

- 조회하거나 수정이 복잡해질 수 있기 때문에 하나의 컬럼에 여러값을 두지 않는다.

1. 하나의 컬럼에 같은 종류의 값을 여러개 저장하고 있을 때

   : 해당 컬럼을 하나의 테이블로 분리해서 모델링한다. (전화번호테이블 - ForeignKey : user_id)

2. 하나의 컬럼에 서로 다른 종류의 값을 여러개 저장하고 있을 때

   : 하나의 컬럼을 여러개로 분리해서 모델링한다. (full name -> first_name, middle_name, last_name)

<br/>

### Functional Dependency(함수 종속성)

테이블 안 Attribute들 사이에서 생기는 관계로 X의 값에 따라서 Y의 값이 결정될 때 Y는 X에 함수 종속성이 있다고 한다.

- #### x -> y

  | email -> {name, age, gender}                                 | {user, product} -> score                                     |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | <img src="https://user-images.githubusercontent.com/64063767/116711734-1b58ca80-aa0e-11eb-9705-404a4b6c1554.png" alt="image" style="zoom:50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/116712119-7d193480-aa0e-11eb-8eb7-36ca6e16f2b5.png" alt="image" style="zoom:50%;" /> |

- #### x -> y-> z (이행성)

  product -> brand -> brand_country

  <img src="https://user-images.githubusercontent.com/64063767/116712940-4e4f8e00-aa0f-11eb-9dae-cd16d8250e8e.png" alt="image" style="zoom:50%;" />

<br/>

### Candidate Key

- 하나의 row를 특정지을 수 있는 attribute들의 **최소 집합**

- row를 특정짓는데 사용되지 않는 attribute는 Candidate Key에 포함될 수 없다.

| Candidate Key1                                               | Candidate Key2                                               |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/64063767/116713679-fb2a0b00-aa0f-11eb-8166-eaa4992c2e53.png" alt="image" style="zoom:50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/116713841-20b71480-aa10-11eb-8fd3-96c1fbd6a6c3.png" alt="image" style="zoom:50%;" /> |

<img src="https://user-images.githubusercontent.com/64063767/116714256-886d5f80-aa10-11eb-887f-7528af8d20dd.png" alt="image" style="zoom:50%;" />



<br/>

### (2) 2NF

- 1NF에 부합해야 한다.

- 테이블에 Candidate Key의 일부분에 대해서만 함수 종속성이 있는 non-prime attribute가 없어야 한다.

  | Issue                                                        | Solution                                                     |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | <img src="https://user-images.githubusercontent.com/64063767/116715673-e2225980-aa11-11eb-8193-6464d27d6645.png" alt="image"  /> | <img src="https://user-images.githubusercontent.com/64063767/116715886-172eac00-aa12-11eb-9bb4-0f801a36efec.png" alt="image" style="zoom:50%;" /> |

<br/>

### (3) 3NF

- 1NF에 부합해야 한다.

- 2NF에 부합해야 한다.

- 테이블 안에 있는 모든 attribute들은 오직 Primary Key에 대해서만 함수 종속성이 있어야 한다.
  (테이블의 모든 attribute는 직접적으로 테이블 Entitty에 대한 내용이어야만 한다)

- **이행적 함수 종속성이 존재하면 안된다.**

  | Issue                                                        | Solution                                                     |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | <img src="https://user-images.githubusercontent.com/64063767/116716810-24986600-aa13-11eb-812e-fafd3e489763.png" alt="image" style="zoom:50%;" /> | <img src="https://user-images.githubusercontent.com/64063767/116717016-60333000-aa13-11eb-973c-466e252460d6.png" alt="image" style="zoom:50%;" /> |

<br/>

# Denormalization(비정규화, 반정규화)

- **성능 개선을 위해서** 정규형에 부합하는 테이블을 정규형을 지키지 않게 바꾸는 것을 의미한다.

- 정규화로 데이터가 이곳저곳 너무 많이 퍼져있으면, 퍼져있는 데이터를 다시 모을 때 속도가 느려질 수 있다.

- 비정규화 조건

  1. 데이터가 너무 퍼져있어서 조회 성능 문제가 심각한 수준일 경우
  2. 테이블을 삽입, 업데이트, 삭제하는 것보다 조회하는 용도로만 사용하고 있을때

  이 두 경우에만 비정규화를 고려할 수 있다.

