library(tidyverse)
library(nycflights13)
#4.1 names. 변수 이름 설정할 때는 lower case, _, 숫자만 사용하도록 한다. 이름은 길어도 descriptive하게.
#4.2 수학적 연산들 앞 뒤로는 space를 만들어놔라. 다만 괄호랑 ^ 앞뒤는 띄우지말자. 이름 지정 <- 도 앞 뒤로 띄우기
#일관되게 보여주려고 변수 뒤에 space를 띄워서 = line을 맞추는 것은 괜찮다
flights |> 
  mutate(
    speed      = distance / air_time,
    dep_hour   = dep_time %/% 100,
    dep_minute = dep_time %%  100
  )
#4.3 pipe를 쓰고 나면 line을 바꿀 것. group.by()나 select() 같은 추가 argument가 없는 것들은 가급적 한 줄에
#summarize나 mutate 같은 애들은 각 한 줄에 argument 하나씩
#자동으로 되긴 하지만 pipe 다음에는 두 칸의 space로 indentation, ()를 쓸 때는 ()가 속하는 argument level로 맞추기
#pipe가 10 - 15줄 넘어갈 것 같으면 subtask로 나누고 적절한 이름을 붙여줘라.
#4.4 ggplot2에서도 pipe랑 마찬가지로 한다
flights |> 
  group_by(month) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = month, y = delay)) +
  geom_point() + 
  geom_line()

#4.5 sectioning 하기. ------로 그으면 섹션이 나눠진다. 다 긋기 귀찮지? Ctrl+shift+R 하고 이름 입력하면 됨.
#만들어두면 이동도 가능. 진작 이거 쓸 걸 그러면 괜히 #해서 번호 매겼네
#4.6 Exercises IAH로 가는 비행기들, 각 날짜별로 도착 지연의 평균을 내는데 n수가 10초과인 것들만 평균 내라
flights |> 
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize(
    n = n(),
    mean(arr_delay)
  ) |> 
  filter(n > 10)

#그 다음은 UA항공사에서 IAH 혹은 HOU로 가는데 출발 예정 시간이 9시 이후이고 도착 예정 시간이 20시 이전인 
#항공편들의 도착 지연 시간의 평균, arr_delay 값이 na라면 cancelled로 이름 붙이고 각 n수를 파악할 것. 
#마찬가지로 n수가 10 초과만 살리기
flights |> 
  filter(
    carrier == "UA",
    dest %in% c("IAH", "HOU"),
    sched_dep_time > 0900,
    sched_arr_time < 2000
  ) |> 
  group_by(flight) |> 
  summarize(
    mean(arr_delay, na.rm = TRUE),
    cancelled = is.na(arr_delay),
    n()
  ) |> 
  filter(n() > 10)
