# View

> 조인 등의 작업을 해서 만든 `결과 테이블`이 가상으로 저장된 형태로 `가상 테이블`이라고도 부른다.
>
> 뷰는 일반 테이블처럼 컴퓨터에서 데이터 크기만큼의 물리적 용량을 차지하고 있지 않는다는 차이점이 있다.

<br/>

## 서브쿼리 중첩과 이슈

> 서브쿼리 안의 서브쿼리이며 중첩을 남발하면 SQL 문의 가독성이 현저히 떨어진다.
>
> 이러한 문제는 View 기능으로 해결할 수 있다.

<img src="https://user-images.githubusercontent.com/64063767/112746106-ce856c80-8fe7-11eb-8465-a6654ad32a7a.png" alt="image" style="zoom:50%;" />

```mysql
-- 평균 별점값이 가장 높은 row를 조회(서브쿼리 중첩)
SELECT 
	i.id,
	i.name,
	AVG(star) AS avg_star,
	COUNT(*) AS count_star
FROM item AS i
LEFT OUTER JOIN review AS r ON r.item_id = i.id
LEFT OUTER JOIN `member` AS m ON r.mem_id = m.id
WHERE m.gender = 'f'
GROUP BY i.id, i.name
HAVING COUNT(*) >= 2 
AND avg_star = (
    SELECT MAX(avg_star)
    FROM (
        SELECT 
        i.id,
        i.name,
        AVG(star) AS avg_star,
        COUNT(*) AS count_star
        FROM item AS i 
        LEFT OUTER JOIN review AS r ON r.item_id = i.id
        LEFT OUTER JOIN `member` AS m ON r.mem_id = m.id
        WHERE m.gender = 'f'
        GROUP BY i.id, i.name
        HAVING COUNT(*) >= 2
        ORDER BY AVG(star) DESC, COUNT(*) DESC
    ) AS final
)
ORDER BY AVG(star) DESC, COUNT(*) DESC;
```

<br/>

```mysql
-- 평균 별점값이 가장 높은 row를 조회(View)
CREATE VIEW three_tables_joined AS
SELECT 
	i.id,
	i.name,
	AVG(star) AS avg_star,
	COUNT(*) AS count_star
FROM item AS i 
LEFT OUTER JOIN review AS r ON r.item_id = i.id
LEFT OUTER JOIN `member` AS m ON r.mem_id = m.id
WHERE m.gender = 'f'
GROUP BY i.id, i.name
HAVING COUNT(*) >= 2
ORDER BY AVG(star) DESC, COUNT(*) DESC;

SELECT * FROM three_tables_joined
WHERE avg_star = (
	SELECT MAX(avg_star) FROM three_tables_joined
);
```

<br/>

## View의 장점

- 복잡한 SQL문을 뷰로 한번 저장해두고 재활용할 수 있어서 사용자에게 높은 편의성을 제공한다.

- 각 직무별 데이터 수요에 알맞은, 다양한 구조의 데이터 분석 기반을 구축해둘 수 있다. 같은 테이블들이 존재하는 상황에서도 직무에 따라, 상황에 따라, 필요로 하는 데이터의 종류와 그 구조가 사람마다 다를 수 있다. 이 때 뷰를 사용하면 각자에게 적합한 구조로 데이터들을 준비해둘 수 있기 때문에 기존의 테이블 구조를 건드리지 않고, 풍부한 데이터 분석 기반을 마련할 수 있게 된다.

- 뷰는 **데이터 보안을 제공**한다. 개인정보과 같은 민감한 데이터를 분석가가 마음대로 볼 수없게 뷰로 개인정보 컬럼(or 행)을 제외하고 보여줄 수 있다. (DBMS에서 "사용자별 권한 관리"기능을 통해 employee 테이블에 직접적인 접근을 하지 못하도록 막고, emp_view 뷰에만 접근할 수 있도록 한다)

  ```mysql
  -- 특정 column 제외
  CREATE VIEW emp_view AS
  SELECT id, name, age, department # (registration_number, annual_salary)
  FROM employee;
  
  -- 특정 row 제외
  CREATE VIEW emp_view2 AS
  SELECT id, name, age, department
  FROM employee
  WHERE department != 'secret';
  ```