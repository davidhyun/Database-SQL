# 1. Primary Key

> **Primary Key(기본키)** : 테이블 안에 있는 수많은 row들 중에서 **고유한 하나의 row를 찾을 수 있게끔** 해주는 column이다.
>
> 꼭 모든 테이블에 Primary Key가 있어야하는 것은 아니다. 하지만 특별한 경우가 아닌 이상 일반적으로 테이블에는 Primary Key가 존재하는 것이 바람직하다.
>
> 특정 column을 Primary Key로 설정하면 Primary Key에 같은 값이 있는 row가 추가되는 것을 DBMS가 자동으로 막아주기 때문에 **중복된 row가 생길 위험성이 차단된다.**
>
> Primary Key의 종류로는 Natural Key와 Surrogate Key로 크게 2가지가 있다.

<br/>

### (1) Natural Key

> 실제로 어떤 개체가 갖고 있는 속성을 나타내는 column이 Primary Key가 됐을 때 이를 Natural Key라고 한다. 사람은 **주민등록번호**로 특정 인물을 식별할 수 있고, 책은 **ISBN**이라고 하는 번호로 특정할 수 있다. 바로 이런 속성을 나타내는 column이 Primary Key가 되면 Natural Key라고 한다.
>
> member 테이블에서는 email 컬럼이 각 회원을 식별할 수 있는 실제 속성이다. id가 아닌 email을 Primary Key로 지정했다면 Primary Key가 Natural Key가 되는 것이다.
>
> 단, Natural Key는 주민등록번호가 변경되는 것처럼 그 값이 나중에 변경되면 모든 row의 값들을 수정해줘야하는 문제가 생길수도 있기 때문에 Surrogate Key를 선택하는 경우가 많다.

<br/>

### (2) Surrogate Key

> member 테이블에서 지정했던 id 컬럼같은 Primary Key를 의미한다. id 컬럼은 어떤 회원의 속성을 직접적으로 나타내는 컬럼은 아니다. 단지 Primary Key로 사용하기 위해 **인위적으로 생성한 컬럼**이다. 이렇게 **어떤 개체의 실제 속성은 아니지만 Primary Key로 쓰기 위해 추가한 컬럼**을 Surrogate Key라고 한다. 이런 Surrogate Key에는 주로 1부터 순차적으로 증가하는 숫자가 들어가게 된다.



# 2. NULL

> **NULL** : 값이 존재하지 않는 상태(값이 없음)
>
> NULL != 0
>
> NULL != ""
>
> Not NULL : 이 column에는 반드시 어떤 값이 들어있어야 한다.
>
> **Primary Key로 지정된 column은 반드시 Not NULL이어야 한다.**