#子查询
#子查询 select语句中嵌套select语句，被嵌套的select语句称之为子查询
/*子查询出现的地方
select ..(select)
from ..(select)
where ..(select)
*/
#where子句的子查询
#找出比最低工资高的员工  ①先查询最低工资员工，②在查询比最低工资高的员工
SELECT MIN(sal) FROM emp;
SELECT ename,sal FROM emp WHERE sal > (SELECT MIN(sal) FROM emp);

#form子句的子查询 form后面的子查询可以当做成一张临时表
# 找出每个工作岗位的平均工资的薪资等级  
#①先找出每个岗位的平均工资 ②在找出找出每个工作岗位的平均工资的薪资等级  
SELECT job,AVG(sal) avgsal FROM emp GROUP BY job;
SELECT t.job,t.avgsal,s.grade
FROM (SELECT job,AVG(sal) avgsal FROM emp GROUP BY job) t 
	JOIN salgrade s ON t.avgsal BETWEEN s.losal AND s.hisal
	ORDER BY s.grade;
	
#select子句后的子查询，这个子查询只要查出结果多于1条记录就会报错
#=====================================================================


#union合并查询结果集
#查询job为 MANAGER 和 SALESMAN 的员工
SELECT ename,job FROM emp WHERE job = 'SALESMAN' OR job = 'MANAGER';
SELECT ename,job FROM emp WHERE job IN ('SALESMAN' , 'MANAGER');
#union写法
SELECT ename,job FROM emp WHERE job = 'SALESMAN' 
UNION
SELECT ename,job FROM emp WHERE job = 'MANAGER' 
#union效率高 union把原本两表连接的乘法操作变为两表合并的加法操作，效率提升。
#union在合并俩个结果集是，要求两个结果集的列数相同，有些数据库要求union合并时列与列的数据类型也必须相同
#=====================================================================






