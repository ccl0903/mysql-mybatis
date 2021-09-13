#连接查询
/*
单表查询： 在一张表上进行查询
连接查询： 在多张表进行连接查询
根据表单的连接方式分为:
内连接：
	等值连接
	非等值连接
	自连接
外连接：
	左外连接（左连接）
	右外连接（右连接）
全连接（mysql不支持全连接）
*/
SELECT *FROM `salgrade`

#笛卡尔乘积 
#当两张表进行连接查询是，没有任何条件限制是，最终查询结果条数为两张表的乘积，这种现象称之为笛卡尔乘积
SELECT ename,dname FROM emp,dept;
#如何避免笛卡尔乘积？ 需要在连接多张表时加上一些条件限制。
#下面例子表面上看查询结果正确，似乎没有出现笛卡尔乘积，但实际上还是emp的每一个字段去匹配dept的每一个字段
#下面两种方式的匹配次数并没有减少，只有是在显示的时候进行4选1，本质上还是进行了笛卡尔乘积匹配，只不过where与on后有条件筛选出有效数据
SELECT ename,dname 
FROM emp,dept 
WHERE emp.deptno = dept.deptno;

SELECT	e.ename,d.dname
FROM emp e JOIN dept d
ON e.deptno = d.deptno;
#====================================================================



#内连接 （无主表之分）
#1、等值连接  条件是一个等量关系，称之为等值连接
#sql92语法
SELECT	e.ename,d.dname
FROM emp e,dept d
WHERE e.deptno = d.deptno;
#sql99语法 【结构清晰】
SELECT	e.ename,d.dname
FROM emp e INNER JOIN dept d ON e.deptno = d.deptno;

#2、非等值连接	条件不是是一个等量关系，称之为非等值连接
#2.1、找出每个员工的薪资等级，要求显示员工名，薪资，薪资等级。
SELECT e.ename,e.sal,s.grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;

#3、自连接   （自己连接自己）
#3.1、查询员工的上级领导，显示员工名和对应领导名
SELECT e1.ename '员工名', e2.ename '领导名'
FROM emp e1 JOIN emp e2 ON e1.mgr = e2.empno;
#====================================================================



#外连接	（有主从表之分）
#1、左外连接  把左边的表当成主表，把右边的表当成从表，和左表相等的不相等都会显示出来，右表符合条件的显示,不符合条件的不显示
SELECT e.ename,d.dname
FROM emp e LEFT JOIN dept d ON e.deptno = d.deptno;

#2、右外连接  把右边的表当成主表，把左边的表当成从表，和右表相等的不相等都会显示出来，左表符合条件的显示,不符合条件的不显示
SELECT e.ename,d.dname
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno;
#2.1、查询每个员工的上级领导，要求显示所有员工的姓名与领导名
#左连接方式
SELECT e1.ename AS '员工名',e2.ename AS '领导名'
FROM emp e1 LEFT JOIN emp e2 ON e1.mgr = e2.empno;
#右连接方式
SELECT e1.ename AS '领导名',e2.ename AS '员工名'
FROM emp e1 RIGHT JOIN emp e2 ON e2.mgr = e1.empno;
#====================================================================


#多表连接
/*
select ...
from a join b on a和b的连接条件
	left join c on a与c的连接条件
	right join d on a与d的连接条件
	......
【注意】 一条sql语句中可以内连接外连接混合使用。
*/
#找出每个员工的部门名称，上级领导以及工资等级，要求显示员工名，部门名，领导名，薪资和薪资等级
SELECT	e.ename,d.dname,e.sal,s.grade,e2.ename AS '领导名'
FROM emp e LEFT JOIN dept d ON e.deptno = d.deptno
	  JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
	  LEFT JOIN emp e2 ON e.mgr = e2.empno;
#====================================================================




