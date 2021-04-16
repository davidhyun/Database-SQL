# Structured Query Language

> SQL은 관계형 데이터베이스 관리시스템(RDBMS)의 데이터를 관리하기 위해 설계된 특수목적의 프로그래밍 언어이다.
>
> RDBMS에서 데이터의 조회와 관리, 데이터베이스 스키마 생성과 수정, 데이터베이스 객체 접근 조정관리를 위해 고안되었다.

<br/>

## SQL 문법의 종류

### DDL(Data Definition Language, 데이터 정의 언어)

> 각 **릴레이션을 정의하기 위해** 사용하는 언어
>
> `CREATE`, `ALTER`, `DROP`, ...

<br/>

### DML(Data Manipulation Language, 데이터 조작 언어)

> 데이터를 추가/수정/삭제하기 위한, 즉 **데이터 관리를 위한** 언어
>
> `SELECT`, `INSERT`, `UPDATE`, ...

<br/>

### DCL(Data Control Language, 데이터 제어 언어)

> 사용자 관리 및 사용자별로 릴레이션 또는 **데이터를 관리하고 접근하는 권한을 다루기 위한** 언어
>
> `GRANT`, `REVOKE`, ...

<br/>

## SQL 언어의 특성

1. SQL은 대소문자를 가리지 않는다. 

   (단, 서버 환경이나 DBMS 종류에 따라 데이터베이스 또는 필드명에 대해 대소문자를 구분하기도 한다)

2. SQL 명령은 반드시 `세미콜론(;)`으로 끝나야 한다.

3. 고유의 값은 `따옴표('')`로 감싸준다.

4. SQL에서 객체를 나타낼 때는 `백틱(``)`으로 감싸준다.

5. 주석은 일종의 도움말로, 주석 처리된 문장은 프로그램에서 동작하지 않는다.

   한줄 주석은 문장 앞에 `--` 를 붙여서 사용한다.

   여러줄 주석은 `/* */`로 감싸준다.

<br/>

---

## 스키마(Schema)

**데이터베이스에 관한 모든 설계사항**

>- '스키마는 만드셨나요?'
>- '이번에 앱이 업데이트되면 스키마에 큰 변화가 있을 것 같습니다.'
>- '스키마가 우리 비즈니스 상황에 최적화되지 않은 것 같군요'

어떤 데이터베이스를 새롭게 구축할 때는 가장 처음에 '스키마'를 짜야한다. 이 스키마를 짜는 것을 '**데이터베이스 모델링**' 또는 '**데이터베이스 디자인**'이라고 한다.

그런데 각 DBMS마다 스키마(Schema)를 다르게 정의하여 사용하고 있다. MySQL에서는 스키마 = 데이터베이스, Oracle에서는 스키마는 하나의 사용자가 만든 각종 객체(테이블, 뷰 등)의 집합을 의미한다.

<br/>

### 개념적 스키마(Conceptual Schema)

하나의 조직, 하나의 기관, 하나의 서비스 등에서 필요로 하는 데이터베이스 설계사항을 의미한다. 보통 스키마라고 하면 이 개념적 스키마를 의미한다.

### 물리적 스키마(Physical Schema)

물리적 스키마는 데이터를 실제로 컴퓨터의 저장장치에 어떤 방식으로 저장할 것인지를 결정하는 스키마이다. 만약 member라는 테이블이 있고 그 안에 id, name, age 등의 컬럼이 있을 때 각 컬럼의 값들을 어떤 방식으로 저장할지에 관한 설계사항이다. 그래서 물리적 스키마는 **저장 스키마(Storage Schema)**, **내부 스키마(Internal Schema)**라고도 한다.

물리적 스키마는 일반 개발자나, 사용자가 다룰 일이 없다. MySQL, Oracle과 같은 DBMS를 만드는 개발자들이 다루는 개념이다. 그리고 똑같은 개념적 스키마더라도 DBMS에 따라 물리적 스키마는 전혀 달라질 수 있다. 같은 데이터라도 컴퓨터에 실제로 어떻게 저장할지는 DBMS에 따라 다르기 때문이다.

<br/>

---

## 실무에서 데이터베이스 현황 파악

> 기존 직원 분들의 설명을 듣고, 문서화된 자료를 읽는 것이 가장 좋다. 그리고 그것과 동시에 데이터베이스 현황을 간단하게 파악할 수 있는 SQL 문을 알고 직접 적용해보는 것이 좋다.
>
> 회사의 서버에
>
> 1. 어떤 데이터베이스들이 있는지
>
>    ```mysql
>    SHOW DATABASES;
>    ```
>
> 2. 각 데이터베이스 안에 어떤 테이블들이 있는지
>
>    ```mysql
>    -- 하나의 데이터베이스 안의 테이블들(뷰도 포함) 파악
>    SHOW FULL TABLES IN copang_main;
>    ```
>
> 3. 각 테이블의 컬럼 구조는 어떻게 되는지
>
>    ```mysql
>    -- 한 테이블의 컬럼 구조 파악
>    DESCRIBE item;
>    ```
>
> 4. 테이블들 간의 Foreign Key 관계는 어떤지
>
>    ```mysql
>    -- 모든 데이터베이스에서 모든 테이블간의 Foreign Key(외래키) 파악
>    SELECT
>    	i.TABLE_SCHEMA, i.TABLE_NAME, i.CONSTRAINT_TYPE, i.CONSTRAINT_NAME,
>    	k.REFERENCED_TABLE_NAME, k.REFERENCED_COLUMN_NAME
>    FROM information_schema.TABLE_CONSTRAINTS AS i
>    LEFT JOIN information_schema.KEY_COLUMN_USAGE AS k
>    ON i.CONSTRAINT_NAME = k.CONSTRAINT_NAME
>    WHERE i.CONSTRAINT_TYPE = 'FOREIGN KEY';
>    ```
