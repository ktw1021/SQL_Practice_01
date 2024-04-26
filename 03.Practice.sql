--문제1.
--직원들의 사번(employee_id), 이름(firt_name), 성(last_name)과 부서명(department_name)을
--조회하여 부서이름(department_name) 오름차순, 사번(employee_id) 내림차순 으로 정렬하세요.(106건)
SELECT employee_id 사번,
first_name 이름, 
last_name 성, 
department_name 부서명
FROM Employees e
JOIN Departments d ON e.department_id=d.department_id
ORDER BY employee_id DESC;

--문제2.employees 테이블의 job_id는 현재의 업무아이디를 가지고 있습니다.
--직원들의 사번(employee_id), 이름(firt_name), 급여(salary), 부서명(department_name), 현
--재업무(job_title)를 사번(employee_id) 오름차순 으로 정렬하세요.
--부서가 없는 Kimberely(사번 178)은 표시하지 않습니다.(106건)
SELECT employee_id, first_name, salary, department_name, job_title
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
JOIN JOBS j ON e.job_id=j.job_id
ORDER BY employee_id ASC;

--문제2-1.문제2에서 부서가 없는 Kimberely(사번 178)까지 표시해 보세요(107건)
SELECT employee_id, first_name, salary, department_name, job_title
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id(+)
JOIN JOBS j ON e.job_id=j.job_id
ORDER BY employee_id ASC;

--문제3.도시별로 위치한 부서들을 파악하려고 합니다.
--도시아이디(location_id), 도시명(city), 부서명, 부서아이디를, 도시아이디(오름차순)로 정렬하여 출력하세요
--부서가 없는 도시는 표시하지 않습니다.(27건)
SELECT l.location_id, city, department_name, department_id
FROM Departments d 
JOIN Locations l ON d.location_id=l.location_id
ORDER BY city ASC;

--문제3-1.문제3에서 부서가 없는 도시도 표시합니다.(43건)
SELECT l.location_id, city, department_name, department_id
FROM Departments d 
JOIN Locations l ON d.location_id(+)=l.location_id
ORDER BY city ASC;

--문제4.지역(regions)에 속한 나라들을 지역이름(region_name), 나라이름(country_name)으로 출력하되 
--지역이름(오름차순), 나라이름(내림차순) 으로 정렬하세요.(25건)
SELECT region_name, country_name
FROM Regions r
JOIN Countries c ON r.region_id=c.region_id
ORDER BY region_name ASC, country_name DESC;

--문제5.자신의 매니저보다 채용일(hire_date)이 빠른 사원의
--사번(employee_id), 이름(first_name)과 채용일(hire_date), 매니저이름(first_name), 매니저입사일(hire_date)을 조회하세요.(37건)
SELECT e.employee_id 사번, 
e.first_name 이름, 
e.hire_date 채용일, 
e2.first_name 매니저이름, 
e2.hire_date 매니저입사일
FROM Employees e
JOIN Employees e2 ON e.manager_id=e2.employee_id
WHERE e.hire_date < e2.hire_date;

--문제6.나라별로 어떠한 부서들이 위치하고 있는지 파악하려고 합니다.
--나라명, 나라아이디, 도시명, 도시아이디, 부서명, 부서아이디를 
--나라명(오름차순)로 정렬하여 출력하세요.
--값이 없는 경우 표시하지 않습니다.(27건) **
SELECT  
       c.country_name, 
       c.country_id, 
       l.city, 
       l.location_id, 
       d.department_name, 
       d.department_id
FROM Locations l
JOIN Countries c ON l.country_id=c.country_id
JOIN Departments d ON l.location_id = d.location_id
ORDER BY c.country_name ASC;

--문제7.job_history 테이블은 과거의 담당업무의 데이터를 가지고 있다.
--과거의 업무아이디(job_id)가 ‘AC_ACCOUNT’로 근무한 사원의 사번, 이름(풀네임), 업무아이디, 시작일, 종료일을 출력하세요.
--이름은 first_name과 last_name을 합쳐 출력합니다.(2건)
SELECT jh.employee_id, 
first_name || ' ' || last_name "이름(풀네임)",
jh.job_id 업무ID, 
start_date 시작일, 
end_date 종료일
FROM Employees e
JOIN Job_history jh ON e.employee_id = jh.employee_id
WHERE jh.job_id = 'AC_ACCOUNT';

--문제8.각 부서(Department)에 대해서, 
--부서번호(department_id), 부서이름(department_name),매니저(manager)의 이름(first_name), 
--위치(Locations)한 도시(city), 나라(countries)의 이름(countries_name) 
--그리고 지역구분(Regions)의 이름(resion_name)까지 
--전부 출력해 보세요.(11건)
SELECT d.department_id,
       d.department_name,
       e.first_name,
       l.city,
       c.country_name,
       r.region_name
    FROM Departments d
    JOIN Employees e ON d.manager_id=e.employee_id
    JOIN Locations l ON d.location_id=l.location_id
    JOIN Countries c ON l.country_id=c.country_id
    JOIN Regions r ON r.region_id=c.region_id
    GROUP BY d.department_id, d.department_name, e.first_name, l.city, c.country_name, r.region_name;
    
--문제9.각 사원(employee)에 대해서, 
--사번(employee_id), 이름(first_name), 부서명(department_name), 매니저(manager)의 이름(first_name)을 조회하세요.
--부서가 없는 직원(Kimberely)도 표시합니다.(106명)

SELECT e.employee_id 사번, 
e.first_name 사원명, 
d.department_name 부서명, 
e2.first_name 매니저
FROM Employees e
LEFT OUTER JOIN Departments d ON e.department_id=d.department_id
JOIN Employees e2 ON e.manager_id=e2.employee_id
