# JOIN

> 여러개의 테이블을 합쳐서 하나의 테이블인 것처럼 보는 것을 `JOIN`이라고 한다.

<br/>

## 1. Foreign Key

> 한 테이블의 컬럼이 다른 테이블의 컬럼을 **참조**하는 관계일 때, '다른 테이블의 특정 row를 식별할 수 있게 해주는 컬럼'을 `Foreign Key(외래키)`라고 한다.
>
> 참조를 하는 테이블을 **자식 테이블**, 참조를 당하는 테이블을 **부모 테이블**이라고 한다.
>
> Foreign Key는 다른 테이블의 특정 row를 식별할 수 있어야하기 때문에 주로 다른 테이블의 Primary Key를 참조할 때가 많다.

<img src="https://user-images.githubusercontent.com/64063767/111165807-cb9b7c80-85e2-11eb-808e-a8f1d8acdf6d.png" alt="image" style="zoom:50%;" />

<img src="https://user-images.githubusercontent.com/64063767/111165886-e1a93d00-85e2-11eb-8ac6-ed38442d4181.png" alt="image" style="zoom:50%;" />