# 従業員番号が499999の従業員の給料全てを取得してください
## ActiveRecordの場合
```rb
Salary.where(emp_no: 499999)
```
[![Image from Gyazo](https://i.gyazo.com/38726bdca9a5c184a9a7e4e7146933b8.png)](https://gyazo.com/38726bdca9a5c184a9a7e4e7146933b8)

## SQLの場合
```sql
select *
from salaries
where emp_no = 499999;
```

[![Image from Gyazo](https://i.gyazo.com/1b7b1f658d291f61ec39b9af4d2576ed.png)](https://gyazo.com/1b7b1f658d291f61ec39b9af4d2576ed)


# 従業員番号が499999の従業員の2001-01-01時点の給料を取得してください

## ActiveRecordの場合
```rb
Salary.all.where("emp_no = 499999 and to_date >= '2001-01-01' and from_date <= '2001-01-01'" )

```

[![Image from Gyazo](https://i.gyazo.com/5c004ef99f3fac5d4589e90b871bda05.png)](https://gyazo.com/5c004ef99f3fac5d4589e90b871bda05)

## SQLの場合
```sql
select * 
from salaries 
where emp_no = 499999 
and to_date >= '2001-01-01' 
and from_date <= '2001-01-02';

```

[![Image from Gyazo](https://i.gyazo.com/a83298c85c04845dd516226d87a3aafd.png)](https://gyazo.com/a83298c85c04845dd516226d87a3aafd)

# 150000以上の給料をもらったことがある従業員の一覧を取得してください

## ActiveRecordの場合

```rb
Employee.joins(:salaries).where('salaries.salary >= 150000').distinct
```
[![Image from Gyazo](https://i.gyazo.com/a0eccb492ab44113b83735b9776b58b0.png)](https://gyazo.com/a0eccb492ab44113b83735b9776b58b0)

[![Image from Gyazo](https://i.gyazo.com/b3bfb63d92d25ad7088c599b8d4868ca.png)](https://gyazo.com/b3bfb63d92d25ad7088c599b8d4868ca)

## SQLの場合
```sql
select distinct e.* 
from employees as e 
join salaries as s 
on s.emp_no = e.emp_no 
where s.salary >= 150000;
```

[![Image from Gyazo](https://i.gyazo.com/3b2dec760bdea0c5d23975babd6d7135.png)](https://gyazo.com/3b2dec760bdea0c5d23975babd6d7135)

# 150000以上の給料をもらったことがある女性従業員の一覧を取得してください

## ActiveRecordの場合

```rb
Employee.joins(:salaries).where('salaries.salary >= 150000 and employees.gender = 'F'").distinct
```
[![Image from Gyazo](https://i.gyazo.com/a88a3d05c09bdd02f1ded426df01f7d2.png)](https://gyazo.com/a88a3d05c09bdd02f1ded426df01f7d2)

## SQLの場合
```sql
select distinct e.* 
from employees as e 
join salaries as s 
on s.emp_no = e.emp_no 
where s.salary >= 150000 
and e.gender = 'F';
```
[![Image from Gyazo](https://i.gyazo.com/fe26f62bb00d236c9e7183d272c6b154.png)](https://gyazo.com/fe26f62bb00d236c9e7183d272c6b154)

# どんな肩書きがあるか一覧で取得してきてください

## ActiveRecordの場合

```rb
Title.group(:title).select(:title)
```

[![Image from Gyazo](https://i.gyazo.com/22f9901a64153abdad2e40c6522c79ad.png)](https://gyazo.com/22f9901a64153abdad2e40c6522c79ad)

## SQLの場合
```sql
select title
from titles
group by title;
```
[![Image from Gyazo](https://i.gyazo.com/30ef0981c1d36d6f8a824e10d7b0eba0.png)](https://gyazo.com/30ef0981c1d36d6f8a824e10d7b0eba0)

# 2000-1-29以降に肩書きが「Technique Leader」になった従業員を取得してください

## ActiveRecordの場合

```rb
Employee.joins(:titles).where("titles.from_date >= '2000-01-29' and titles.title = 'Technique Leader'")
```
[![Image from Gyazo](https://i.gyazo.com/1594c950fe5c1b3bd61af7d8e25115a1.png)](https://gyazo.com/1594c950fe5c1b3bd61af7d8e25115a1)

## SQLの場合
```sql
select e.* 
from employees as e 
join titles as t 
on t.emp_no = e.emp_no 
where t.title = 'Technique Leader' 
and from_date >= '2000-01-29';
```

[![Image from Gyazo](https://i.gyazo.com/6d348907352ac328bf29f1da469e5349.png)](https://gyazo.com/6d348907352ac328bf29f1da469e5349)



# 部署番号がd001である部署のマネージャー歴代一覧を取得してきてください

## ActiveRecordの場合
```rb
Employee.joins(dept_managers: :department).where("departments.dept_no = 'd001'")
```

[![Image from Gyazo](https://i.gyazo.com/911f4e1b9711397b6607870d49d06918.png)](https://gyazo.com/911f4e1b9711397b6607870d49d06918)


## SQLの場合
```sql
select e.* 
from employees as e 
join dept_manager as dm 
on dm.emp_no = e.emp_no 
join departments as d 
on d.dept_no = dm.dept_no 
where d.dept_no = 'd001';
```

[![Image from Gyazo](https://i.gyazo.com/64b6565d51fcc73b14387658d10ba7b3.png)](https://gyazo.com/64b6565d51fcc73b14387658d10ba7b3)


# 歴代マネージャーにおける男女比を出してください
## ActiveRecordの場合
```rb
Employee.joins(dept_managers: :department).group(:gender).order(gender: asc).count
```

[![Image from Gyazo](https://i.gyazo.com/9ae28e6c2933a22e21a0761b50c1d8b2.png)](https://gyazo.com/9ae28e6c2933a22e21a0761b50c1d8b2)

## SQLの場合
```sql
select e.gender, count(*) as count_all 
from employees as e 
join dept_manager as dm 
on dm.emp_no = e.emp_no 
join departments as d 
on d.dept_no = dm.dept_no 
group by e.gender;
```
[![Image from Gyazo](https://i.gyazo.com/046b992d94410eee0dde731360a12fe6.png)](https://gyazo.com/046b992d94410eee0dde731360a12fe6)


# 部署番号がd004の部署における1999-1-1時点のマネージャーを取得してください

## ActiveRecordの場合
```rb
Employee.joins(dept_managers: :department).where("departments.dept_no = 'd004' and dept_manager.to_date >= '1999-01-01'")
```

[![Image from Gyazo](https://i.gyazo.com/0cd0378c51982379434532512de7faea.png)](https://gyazo.com/0cd0378c51982379434532512de7faea)

## SQLの場合
```sql
 select e.* 
 from employees as e 
 join dept_manager as dm 
 on dm.emp_no = e.emp_no 
 join departments as d 
 on d.dept_no = dm.dept_no 
 where d.dept_no = 'd004' 
 and dm.to_date >= '1999-01-01';
```
[![Image from Gyazo](https://i.gyazo.com/833b45c3226741a26f67618785ffbac1.png)](https://gyazo.com/833b45c3226741a26f67618785ffbac1)


# 従業員番号が10001, 10002, 10003の従業員が今までに稼いだ給料の合計を従業員ごとに集計してください
## ActiveRecordの場合
```rb
Salary.where(emp_no: [10001, 10002,10003]).group(:emp_no).sum(:salary)
```


[![Image from Gyazo](https://i.gyazo.com/9959d2461dfe99cf6c0fef7a3a32a1ab.png)](https://gyazo.com/9959d2461dfe99cf6c0fef7a3a32a1ab)
## SQLの場合
```sql
select emp_no, sum(salary) as total_salary 
from salaries 
where emp_no in (10001,10002,10003) 
group by emp_no;
```

[![Image from Gyazo](https://i.gyazo.com/a3d08ad0fed11d977f5f45c399485a26.png)](https://gyazo.com/a3d08ad0fed11d977f5f45c399485a26)

# 上記に加えtotal_salaryという仮のフィールドを作ってemployeeの情報とがっちゃんこしてください。
## ActiveRecordの場合
```rb
Employee.joins(:salaries).where(emp_no: [10001, 10002,10003]).group(:emp_no),select("employees.*, sum(salary) as total_salary")
```


[![Image from Gyazo](https://i.gyazo.com/cf1b3ef31fbc2a66666899e9651979f0.png)](https://gyazo.com/cf1b3ef31fbc2a66666899e9651979f0)

## SQLの場合
```sql
select e.*, sum(salary) as total_salary 
from employees as e 
join salaries as s 
on s.emp_no = e.emp_no 
where e.emp_no in (10001,10002,10003) 
group by emp_no;
```

[![Image from Gyazo](https://i.gyazo.com/5b8b8ad96f80bed23a7c12abd6aa1825.png)](https://gyazo.com/5b8b8ad96f80bed23a7c12abd6aa1825)

# 上記の結果を利用してコンソール上に以下のようなフォーマットでputsしてください。
```rb
Employee.joins(:salaries).where(emp_no: [10001,10002,10003]).group(:emp_no).select("employees.*, sum(salary) as total_salary ").each do |e|
    puts "emp_no: #{e.emp_no}"
    puts "full_name: #{e.first_name} #{e.last_name}"
    puts "total_salary: #{e.total_salary}"
end

```

[![Image from Gyazo](https://i.gyazo.com/1e0dc89498bf095c683ccc7698de9224.png)](https://gyazo.com/1e0dc89498bf095c683ccc7698de9224)
