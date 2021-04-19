# Basic Concept of Data Modeling

**Data Modeling** : 데이터를 "어떻게" 저장할지 계획하는 것

논리적 모델링과 물리적 모델링이 잘 되어야 성능이 좋고, 확장성이 높은 데이터베이스를 구축할 수 있다.

- 논리적 모델링 : 개념적 구조를 정하는 것 (테이블 나누기, 컬럼간 연결 구조 등)
- 물리적 모델링 : 데이터베이스 구축에 필요한 걸 정하는 것 (컬럼 이름, 데이터 타입, 제약 조건 등)

<br/>

## 데이터베이스 모델링의 중요성

같은 데이터를 저장하고 있어도 데이터 모델링을 어떻게 했는지에 따라 좋은 데이터베이스가 될 수도 있고 나쁜 데이터베이스가 될 수도 있다.

<img src="https://user-images.githubusercontent.com/64063767/115254383-3f8fee00-a168-11eb-8ce1-2740d2c8bf19.png" alt="image" style="zoom:50%;" />

| 나쁜 데이터베이스                                            | 좋은 데이터베이스                                            |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="https://user-images.githubusercontent.com/64063767/115255529-52ef8900-a169-11eb-9cf8-61f854084cc4.png" alt="image"  /> | <img src="https://user-images.githubusercontent.com/64063767/115255389-2b98bc00-a169-11eb-824b-f1b098d0da88.png" alt="image"  /> |
| <img src="https://user-images.githubusercontent.com/64063767/115255581-5edb4b00-a169-11eb-8fe2-ad05b0fa1cd8.png" alt="image"  /> |                                                              |

<br/>

## Data Model

데이터를 사용하려는 목적에 맞게 정리하고 체계화해놓은 모형

| 이름                 | 설명                                 | 표현   | 예시                                    |
| -------------------- | ------------------------------------ | ------ | --------------------------------------- |
| Entity(개체)         | 저장하고 싶은 데이터의 대상 하나하나 | row    | 학생 한명, 수업 하나, 교수 한명         |
| Entity Type          | 일반화한 Entity 종류                 | table  | 테이블 전체                             |
| Attribute(속성)      | Entity에 대해서 저장하려는 내용      | column | 학번, 이름, 성별, 전공                  |
| Relationship(관계)   | Entity들 사이의 연결점               |        |                                         |
| Constraint(제약조건) | 각 데이터들에 대한 일종의 규칙       |        | 학생의 고유번호, 적어도 한명의 지도교수 |

<br/>

## Relational Model

**Relation** : "**테이블**"을 의미하는 수학적 표현

데이터를 row와 column으로 이뤄진 테이블로 표현한 모델을 **Relational Model(관계형 모델)**이라고 한다.

- Relational Model의 단점

  - 데이터의 구조를 정할 때는 row 자체는 큰 의미가 없다.

  - 테이블 사이들의 관계를 한눈에 알아보기 힘들다.

<br/>

## Entity Relationship Model(ERM)

- 모델링할 때는 row에 대해서 신경쓰지 않고 개체와 관계를 중심으로 표현한 ERM 모델을 사용한다.

<img src="https://user-images.githubusercontent.com/64063767/115251608-a9f35f00-a165-11eb-91a8-f4b6286486d5.png" alt="image" style="zoom: 50%;" />

<img src="https://user-images.githubusercontent.com/64063767/115251846-e626bf80-a165-11eb-91e6-932bb928b06a.png" alt="image" style="zoom:50%;" />

<br/>

## 데이터 모델 스펙트럼

- 물리 모델, 논리 모델, 개념 모델 순으로 구체적이다.

- 모델을 얼마나 추상적 또는 구체적으로 만들지는 데이터베이스를 만드는 과정에서 어떤 단계에 있는지 데이터 모델을 만드는 목적에 따라 달라질 수 있다.

### (i) 개념 모델(Conceptual Model)

- 경영인 또는 기획자 단계의 모델

- 가장 추상적인 모델로 큼지막한 Entity와 간단한 연결관계만을 나타낸다.

- attribute(속성)는 구체화하지 않고 개략적인 구조를 파악할 때 주로 사용한다.

<img src="https://user-images.githubusercontent.com/64063767/115252449-71a05080-a166-11eb-9e92-d2b8f567c5ba.png" alt="image" style="zoom:50%;" />

<br/>

### (ii) 논리 모델(Logical Model)

- 개발자 구체화 단계의 모델

<img src="https://user-images.githubusercontent.com/64063767/115252663-a3b1b280-a166-11eb-80fe-8513a8e1a1fa.png" alt="image" style="zoom:50%;" />

<br/>

### (iii) 물리 모델(Physical Model)

- 데이터베이스 구축 단계의 모델

- 실제로 이 모델을 가지고 데이터 베이스를 구축할 수 있을 정도로 구체화된 모델

<img src="https://user-images.githubusercontent.com/64063767/115252822-c643cb80-a166-11eb-8231-43a48584bb7e.png" alt="image" style="zoom:50%;" />

<br/>

