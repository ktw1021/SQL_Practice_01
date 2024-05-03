-- 문제1. 담당 매니저가 배정되어있으나 커미션비율이 없고, 월급이 3000초과인 직원의
-- 이름, 매니저 아이디, 커미션 비율, 월급을 출력하세요.(45건)
SELECT first_name, manager_id, NVL(commission_pct,0), salary
        FROM Employees
    WHERE manager_id IS NOT NULL 
    AND commission_pct IS NULL
    AND salary >3000;
    
-- 문제2. 각 부서별로 최고의 급여를 받는 사원의 
--직원번호(employee_id), 이름(first_name), 급여(salary), 
--입사일(hire_date), 전화번호(phone_number), 부서번호(department_id)를 조회하세요
--조건절 비교 방법으로 작성하세요
--급여의 내림차순으로 정렬하세요
--입사일은 2001-01-13 토요일 형식으로 출력합니다.
--전화번호는 515-123-4567 형식으로 출력합니다.(11건)

    SELECT employee_id 사원번호, 
        first_name 이름, 
        salary 최고급여, 
        TO_CHAR(hire_date,'yyyy-mm-dd day') 입사일,
        SUBSTR(REPLACE(phone_number,'.','-'),3) 전화번호,
        department_id 부서ID
    FROM Employees
    WHERE (department_id, salary) IN (SELECT department_id, MAX(salary)
        FROM Employees
        GROUP BY department_id
            )
    ORDER BY salary DESC;
    
--문제3. 매니저별로 평균급여, 최소급여, 최대급여를 알아보려고 한다.
--통계대상(직원)은 2015년 이후의 입사자 입니다.
--매니저별 평균급여가 5000이상만 출력합니다.
--매니저별 평균급여의 내림차순으로 출력합니다.
--매니저별 평균급여는 소수점 첫째자리에서 반올림 합니다.
--출력내용은 매니저 아이디, 매니저이름(first_name), 
--매니저별 평균급여, 매니저별 최소급여,매니저별 최대급여 입니다.(9건)
        
        SELECT e.manager_id 매니저ID, 
                e2.first_name 매니저명,
                ROUND(AVG(e.salary)) 평균급여,
                MIN(e.salary) 최소급여,
                MAX(e.salary) 최대급여
        FROM Employees e
        JOIN Employees e2 ON e.manager_id=e2.employee_id
        WHERE e.hire_date > '2014-12-31'
        GROUP BY e.manager_id, e2.first_name
        HAVING AVG(e.salary) >= 5000
        ORDER BY AVG(e.salary) DESC
        ;

--문제4.각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 부서명
--(department_name), 매니저(manager)의 이름(first_name)을 조회하세요.
--부서가 없는 직원(Kimberely)도 표시합니다.(106명)
    SELECT e.employee_id, e.first_name, d.department_name, e2.first_name
    FROM Employees e
    Join Employees e2 ON e.manager_id=e2.employee_id
    LEFT JOIN Departments d On e.department_id=d.department_id;
    
--문제5. 2015년 이후 입사한 직원 중에 입사일이 11번째에서 20번째의 직원의
--사번, 이름, 부서명, 급여, 입사일을 입사일 순서로 출력하세요
    SELECT employee_id, first_name, department_name, salary, hire_date
        FROM (
        SELECT ROW_NUMBER () OVER (ORDER BY hire_date) rn,
        e.employee_id, e.first_name, d.department_name, e.salary, hire_date
        FROM Employees e
        JOIN Departments d ON e.department_id=d.department_id
        WHERE e.hire_date > '2014/12/31'
        )
        WHERE rn >= 11 AND rn<= 20
        ORDER BY hire_date 
        ;
--문제6. 가장 늦게 입사한 직원의 
--이름(first_name last_name)과 연봉(salary)과 근무하는 부서 이름(department_name)은?
SELECT e.first_name || ' ' || e.last_name 이름, e.salary 급여, d.department_name 부서이름, e.hire_date
        FROM Employees e
        JOIN Departments d ON e.department_id=d.department_id
        WHERE e.hire_date = (
                        SELECT MAX(hire_date)
                        FROM Employees
                        );
--문제7. 평균연봉(salary)이 가장 높은 부서 직원들의 
--직원번호(employee_id), 이름(firt_name), 성(last_name)과 업무(job_title), 연봉(salary)을 조회하시오.
SELECT e.employee_id 사번, e.department_id 부서ID, e.first_name 이름, e.last_name 성, j.job_title 업무, e.salary 연봉, 
ROUND((SELECT AVG(salary) FROM Employees WHERE department_id = (
            SELECT department_id FROM (
                    SELECT department_id FROM Employees GROUP BY department_id ORDER BY AVG(salary) DESC
                                        ) WHERE ROWNUM = 1
                                  )
                            )) 부서평균
    FROM Employees e
    JOIN Jobs j ON e.job_id = j.job_id
    WHERE department_id IN (
            SELECT department_id
            FROM (
                    SELECT department_id
                    FROM Employees
                    GROUP BY department_id
                    ORDER BY AVG(salary) DESC
                    )
                    WHERE rownum = 1
    );
--문제8.평균 급여(salary)가 가장 높은 부서는?
SELECT d.department_name
    FROM Departments d
    JOIN Employees e ON d.department_id = e.department_id
    WHERE department_name = (
            SELECT department_name
            FROM (
                SELECT department_name
                FROM Departments d2
                JOIN Employees e2 ON d2.department_id = e2.department_id
                GROUP BY d2.department_name
                ORDER BY AVG(e2.salary) DESC
                )
            WHERE rownum = 1
        )
        AND rownum=1;
--문제9. 평균 급여(salary)가 가장 높은 지역은?
SELECT region_name
    FROM Regions r
    JOIN Countries c ON r.region_id = c.region_id
    JOIN Locations l ON c.country_id = l.country_id
    JOIN Departments d ON l.location_id = d.location_id
    JOIN Employees e ON d.department_id = e.department_id
    WHERE region_name = (
        SELECT region_name 
        FROM (
            SELECT region_name
            FROM Regions r2
            JOIN Countries c2 ON r2.region_id = c2.region_id
            JOIN Locations l2 ON c2.country_id = l2.country_id
            JOIN Departments d2 ON l2.location_id = d2.location_id
            JOIN Employees e2 ON d2.department_id = e2.department_id
            GROUP BY r2.region_name
            ORDER BY AVG(e2.salary) DESC
            )
            WHERE rownum = 1
            )
            AND rownum = 1;

--문제10. 평균 급여(salary)가 가장 높은 업무는?
SELECT job_title 
    FROM Jobs j
    JOIN Employees e ON j.job_id = e.job_id
    WHERE job_title = (
            SELECT job_title
            FROM (
                SELECT job_title
                FROM Jobs j2
                JOIN Employees e2 ON j2.job_id = e2.job_id
                GROUP BY j2.job_title
                ORDER BY AVG(e2.salary) DESC
                )
                WHERE rownum = 1
            )
    AND rownum = 1;