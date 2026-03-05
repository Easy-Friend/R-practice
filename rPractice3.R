#3 Data transformation
library (tidyverse)
library (nycflights13)

#오늘 쓸 data는 flights. tibble이라는 dataframe type이 있는데 그거임.
#보면 <int>는 integer, <dbl>은 double(실수), <chr>은 character, <dttm>은 date-time
#3.1 dplyr를 배워볼 건데 첫 argument는 항상 dataframe 이어야하고, 그 다음은 operation할 column을 quote 없이 씀
#output은 역시 또 dataframe임. 그래서 |>를 자주 쓰게 되는 것.
#3.2 우선은 rows에 작용하는 기능들부터. filter, arrange, distinct, count를 배울 것임
#3.2.1 filter() 는 순서는 그대로 두면서 조건이 참인 행만을 뽑아내는 것.
flights |>
  filter(dep_delay >= 60)
#이렇게 하면 기존 336776 rows 이던 것이 27059 행만 남게 됨. 이 논리연산에 and(, 혹은 &), or( | )을 추가할 수도 있음.
#당연하지만 data frame을 바꾸는 것은 아니네. 말 그대로 엑셀의 필터 기능. 잠시 해당하는 애들만 남겨서 보여주는 것.
#유용한 shortcut에 %in% 가 있는데 이는 == | == 을 합친 것임. 이해가 안간다면 예시로
flights |> 
  filter(month %in% c(1, 2)) 

flights |> 
  filter(month == 1 | month == 2) #라 할 수 있겠다 ㅇㅇ참고로 month == 1 | 2 는 완전히 다른 것임.
#저장하고 싶다면 새로 지정해줘야함
flights_delayeds <- flights |>
  filter(dep_delay > 120)


#3.2.3 arrange() 이거는 rows의 order를 바꿈. 여러개를 할 수 도 있다. 역시 본 dataframe을 조작하는 것은 아님
flights |>
  arrange(year, month, day, dep_time)
#역순으로 정리하고 싶으면
flights |> 
  arrange(desc(dep_delay)) #이렇게 하면 됨

#3.2.4 distinct() 이건 unique value를 찾아주는 것. 여러개의 column 조합으로 해도 되고ㅇㅇ
#.keep_all = TRUE를 하면 나머지 열도 살려주기는 하는데 가장 먼저 나온 것만 살린다.
flights |>
  distinct(year, month, .keep_all = TRUE)
#갯수가 세고 싶은거라면 count()를 사용하면 됨. 이건 빈도를 보는 sort = TRUE를 켤 수 있음
flights |>
  count(year, month, sort = TRUE)

#3.2.5 Exercises
#1
flights |>
  filter(arr_delay >= 120 & 
           dest %in% c("IAH", "HOU") &
           carrier %in% c("UA", "AA", "DL") &
           month %in% c(7, 8, 9) & 
           dep_delay <=0)

flights |>
  filter(dep_delay >= 60 & (dep_delay - arr_delay) >30)
#2 이거 잘 모르겠네.. 시간계산이 dep_time이 2400을 넘어가면 1로 찍혀서 dep_time으로 정렬하면 아침이 아닌데
flights |>
  arrange(desc(dep_delay)) |>
  arrange(dep_time)

flights |>
  arrange(desc(dep_delay)) |>
  arrange(sched_dep_time, dep_delay) #이게 제일 맞겠다. 예정 출발시간 자체가 빠르고 더 일찍 간애 포함가능

#3 가장 빠른 비행기
flights |>
  arrange(desc(distance/(hour*60+minute)))

#4. 2013년에 매일 비행기 떴냐?
flights |>
  filter(year == 2013) |>
  count(month, day)  #365*3 tibble이 나오니 매일 떴음

#5. 가장 장거리/단거리
flights |>
  arrange(distance)
flights |>
  arrange(desc(distance))

#6. 결과는 당연히 차이 없고 일은 filter 먼저 멕이는게 빠르겠지 
flights |>
  filter(month == 1) |>
  arrange(dep_delay)

flights |>
  arrange(dep_delay) |>
  filter(month == 1)

#3.3 다음은 Columns 에 작용하는 기능들을 보겠음. mutate, select, rename, relocate
#3.3.1 mutate() 현존하는 column으로 계산한 새로운 column을 추가하는 기능. default는 가장 우측에 붙인다
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance/air_time*60,
    .before = 1, #.after = 0 은 왜 안되지? 같아야할 느낌인데.. #.before = year 이건 된다ㅇㅇ
    .keep = "used" #이건 사용한 변수만 남기는 것
  )
#근데 일시적이네 이것도. view(flights)를 해보면 여전히 열이 추가가 안돼있음

#3.3.2 select() 이름에서 보이듯이 원하는 항목들만 뽑는 용도. 
flights |>
  select(dep_delay, arr_delay)
#범위로 뽑을 수도, 범위만 제외하고 뽑을 수도 있음
flights |>
  select(!year:day)
#형식으로 뽑을 수도 있음. where은 TRUE or FALSE를 return 하는 것을 변수로 받아 TRUE만 뽑아준다
#is.character
flights |>
  select(where(is.character))
#select와 함꼐 starts_with(""), ends_with(""), contains(""), num_range("x", 1:3) 이렇게 쓸 수 있음
#마지막 것은 x1, x2, x3를 찾는 것
#rename처럼 쓸 수도 있음 
flights |>
  select(tail_num = tailnum) #기존 tailnum을 tail_num으로 바꾸는 것

#3.3.3 rename() 이름대로 이름을 재지정하는 것.
flights |>
  rename(tail_num = tailnum) #위와 동일함ㅇㅇ 대신 보여주는 것을 특정 column 외에도 보여줌

#3.3.4 relocate() 이름대로 위치를 옮김. default는 가장 왼쪽으로 뺀다.
flights |>
  relocate(carrier, tailnum)
#역시 범위나 starts_with("")로 뽑아서 옮길 수 있고, .before, .after 사용 가능
flights |>
  relocate(origin:minute, .before = 1)

#3.3.5 Exercises
#1 쉽네. mutate(dep_delay = dep_time - sched_dep_time, .after = dep_time) 하면 될 일
flights |>
  select(dep_time, sched_dep_time, dep_delay)

flights |>
  mutate(delay = dep_time - sched_dep_time, .before = year) #일단 요정도로 넘어가자
#2. 특정 열들을 뽑는 방법. select, rename, relocate(?)
#3. 여러번 select하면 어떻게 됨? 한 번만 나옴
flights |>
  select(year, month, year)
#4. any_of()가 하는 일은? 그리고 variables 지정하는 것과 어떻게 같이 씀?
vars <- c("year", "month", "day", "dep_delay", "arr_delay", "penguins") #이렇게 지정하면 all_of, any_of를 쓸 수 있음
flights |>
  select(all_of(vars))
#all_of는 vars 항목이 다 있어야하고 any_of는 하나만 있어도 ㄱㅊ
#5 contains는 대소문자 구분 없이 작동하는구나 ㅇㅇ ignore.case = TRUE가 default라 그럼
flights |> 
  select(contains("TIME", ignore.case = FALSE)) #이렇게 하면 안됨ㅇㅇ
#6 air_time 을 air_time_min으로 이름 바꾸고 맨 앞으로 빼라. re
flights |>
  rename(air_time_min = air_time) |>
  relocate(air_time_min, .before = 1)

#3.4 자동으로 해오고 있긴 했는데 pipe의 편의성 설명. Ctrl+shift+m 으로 입력 가능
#예시는 IAH로 가는 비행기를 속도가 빠른 순으로 나열한 것
flights |>
  filter(dest=="IAH") |> 
  mutate(speed = distance/air_time*60) |> 
  select(year:dep_time, dest, speed, carrier:tailnum) |> 
  arrange(desc(speed))

#3.5 dplyr의 가장 강력한 기능인 Groups를 배운다함. group_by()와 summarize().
#3.5.1 group_by()
flights |> 
  group_by(month)
#이걸 한다고 data가 바뀌지는 않지만 이후의 작업은 월 단위로 적용할 수 있게 되는 것. 이걸 class라고 한다
#3.5.2 summarize()
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n()
  )
#이걸 하게 되면 월 단위로 그룹화한 다음, avg_delay를 계산하게 된다. 근데 왜 NA임? missing value 때문
#나중에 결측치 처리를 배우기로 하고 일단 무시하기위해 na.rm 
#,로 구분해서 한 번에 여러 연산을 할 수도 있음, 유용한 기능 중 하나는 n()이고 갯수 세주는 거임
#n=n() 이렇게 이름을 지정해줄 수도 있음
#3.5.3 slice_XXX()임. XXX에는 head, tail, min, max, sample 이 들어갈 수 있다.
#다 행을 따는 행위인데 head는 위에서, tail은 뒤에서, minimum, maximum, sample은 random임
flights |> 
  slice_head(n=1) #flights dataframe의 첫 행 뽑기

flights |> 
  group_by(month) |> 
  slice_head(n=1) #각 월별로 하나씩 뽑기가 되는 것

flights |> 
  group_by(month) |> 
  slice_max(arr_delay, prop = 0.0001) |> 
  relocate(arr_delay, .before=1)
#max, min은 뭘 기준으로 할지이고 n 대신 prop을 쓰면 갯수지정말고 비율로 정리할 수도 있음
#추가로 slice_min, max는 n=1일지라도 동점자가 있으면 같이 뽑는다.

flights |> 
  group_by(month) |> 
  slice_sample(n=1) #진짜 random맞네..
#3.5.4 multiple variable로 grouping하기
#당연하지만 여러 variable로 grouping이 가능함. 이상한건 summarize를 하면 가장 마지막 변수를 날린다(?)
flights |> 
  group_by(year, month, day) |> 
  summarize(
    n()
  )
#이 때 마지막 변수를 제외하고 grouping 했다는 message가 나오고 안나오게 하고싶다면 .groups = "drop_last" 하면 됨
flights |> 
  group_by(year, month, day) |> 
  summarize(
    n(),
    .groups = "keep" #이렇게 하면 grouping 마지막 안날림. 왜 날리는걸까..?
  )

#3.5.5 ungrouping. ㅇㅇ
#우선 grouping부터 해주면 
daily <- flights |> 
  group_by(year, month, day)

daily |> 
  ungroup() |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n()
  )
#당연함. group_by로 안 묶었으니 하나의 group으로 가정, 전체의 avg_delay를 구하는 것임
#근데 새 변수 지정한건 아니니까, 다시 daily하면 grouping 되어있다 

#3.5.6 by. dplyr의 신기능인데 이거 있으면 grouping 안쓸듯? grouping은 지속. .by는 per operation임
flights |> 
  summarise( #s도 z도 다 되네..
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n(),
    .by = month
  )
#마찬가지로 multiple variable로 grouping도 가능함
flights |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n(),
    .by = c(year, month)
  )

#3.5.7 Exercises
#1 최악의 항공사는? 그리고 항공사와 공항의 effect를 분리할 수 있겠는가? 분리는 못하겠는데..
flights |> 
  group_by(carrier) |> 
  summarise(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  ) |> 
  arrange(desc(avg_delay)) #이거만 봤을 때는 F9이고

flights |> 
  group_by(carrier, dest) |> 
  summarise(
    n()
  )

#2 출발 이후 가장 많이 지연 된 항공사는?
flights |> 
  mutate(net_delay = arr_delay - dep_delay) |> 
  summarise(
    net_delay = mean(net_delay, na.rm = TRUE), 
    #net delay 재지정해주는게 안했더니 열 이름이 mean(net_delay, na,rm ~ 이거로 되네)
    n(),
    .by = carrier
    ) |> 
  arrange(net_delay)

#3 delay가 하루 동안 어떻게 달라지는가. 답변을 plot으로 작성해봐라.
#일단 ggplot 받아와야겠고
library(ggplot2)
library(ggthemes)

flights |> 
  distinct(dep_time) #일단 시간대가 1319개인데..

flights |> 
  summarise(
    delay = mean(dep_delay, na.rm = TRUE),
    .by = dep_time,
    n=n()
  )
#이렇게하면 각 dep_time에 따른 delay의 평균과 n수가 나오겠지? 근데 평균 필요 없이 점도표 해버리면 안되나
flights |> 
  ggplot(aes(x=dep_time, y=dep_delay)) +
      geom_point()
#데이터가 많아서인지 좀 걸리네
daily_delay <- flights |> #변수로 설정해버리고
  summarise(
    delay = mean(dep_delay, na.rm = TRUE),
    .by = dep_time,
    n=n()
  )

daily_delay |> 
  ggplot(aes(dep_time, delay)) +
  geom_point() +
  geom_smooth()
#간만에 기억이 새록새록..
#4. slice_head, min, max, sample 여기서 n을 음수로 하면 무슨 일이 생기는가? 그러게?
flights |> 
  group_by(carrier) |> 
  slice_min(arr_delay, n = 2) #이런식으로 쓰는 거였는데 기억 안나서 다시 씀

flights |> 
  group_by(carrier) |> 
  slice_max(arr_delay, n = -2) |> 
  relocate(arr_delay, carrier, .before = 1) #-로 하니 그냥 모든 value를 보여주네
#5. count()의 역할을 설명하고 sort 가 뭐하는지도 말해라. 
#count는 unique value의 갯수를 세는 역할, sort는 빈도 순으로 정리해주는 역할
flights |>
  count(year, month, sort = TRUE)

#6 다음의 data frame을 보고 결과를 예측해봐라
df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
) #x, y, z column이 생기고 각 행에 순차적으로 입력 됨
df |>
  group_by(y)
#이걸 y로 group by 하면? a와 b로 정리되겠지뭐 ㅇㅇ별 차이는 없음
df |>
  arrange(y)
#이거 결과 예상? a나오고 b 나오지 않을까 ㅇㅇ
df |>
  group_by(y) |>
  summarize(mean_x = mean(x))
#당연한거 나오겠지.. 2.66 a, 3.5 b  ㅇㅇ 예상을 안벗어나노
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))
#이건 당연히 1 - a, k / 3.5 - a, L ..이런 식
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x), .groups = "drop")
#같은데 끝나고 나서 group이 사라진다는 것 정도? 하나만이 아니라 전부
#아래 역시 예상하고 차이 생각해보기
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))
#이건 뭐 y로의 group 남고 y, z의 x 평균 mean_x column으로 보여줄거고

df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x))
#이건 mean_x라는 column을 새로 만들어줄 듯. ㅇㅇ예상대로.

#3.6 Case study. Lahman data로 가보자. 
library(Lahman) #여러 dataset의 집합인 library. 그 중 batting을 볼거임
batters <- Batting |> 
  group_by(playerID) |> 
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE)
  )

batters |> 
  filter(n > 100) |> 
  ggplot(aes(x = n, y = performance)) +
  geom_point(alpha = 0.1) + #alpha는 점을 투명하게 하는 역할을 함
  geom_smooth(se = FALSE) #SE는 smooth한 line 근처의 confidence interval을 보여줌 ㅇㅎ. default로 켜져있음
#filter 100이상을 안켜면 당연히 1타석 1안타의 괴물타자만 남음
