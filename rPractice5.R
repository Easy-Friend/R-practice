#5 Data tidying
#tidy하게 data를 유지하는 것. table은 반드시 각 observation은 row, 각 variable은 column이어야함
#이후 내용은 뭐 그닥 중요치는 않은 듯
#5.2 Tidy data 예시
#table1, table2, table3 tibble이 내재되어있음ㅇㅇTB 발생 케이스를 보여주는 표임
#보통 column은 변수, row는 observation, 각 cell은 value임.
library(tidyverse)
#Exercises
#table2에서 rate를 구해봐라. 아직은 기능을 덜배워서 나중에 돌아올 것임

#5.3 Lengthening the data. data를 길게하는 법과 wide 하게 하는 법이 있음. 
#이렇게 data를 row와 column 으로 잘 돌리는 걸 pivoting이라함. pivot_longer() 과 pivot_wider()이 있음
#5.3.1 data in cloumn names
#billboard dataset을 tidy하게 하기. 보면 wk1 ~ 76이 변수인데 column에 가있음. 이걸 정리.
billboard |> 
  pivot_longer(
    cols = starts_with("wk"), #이건 어느 column을 바꿀 건지 선택하는 부분
    names_to = "week", #cols로 불렀던 data를 저장할 column의 이름vector, 지정안하면 name으로 column이 생기고
    values_to = "rank" #cols의 cell 에 들어있던 value를 저장할 이름, 지정안하면 value로 column이 생김
  )
#NA인 row를 없애고 싶다면
billboard |> 
  pivot_longer(
    cols = starts_with("wk"), #이건 어느 column을 바꿀 건지 선택하는 부분
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  )
#이걸 더 tidy하게, wk1 wk2 이걸 단일 변수로 하고 싶으면 mutate을 섞으면 된다
billboard_longer <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week) #parse_number은 숫자만 잘 끊어옴
  )
#그래프로, Q. 그 track 이름으로 legend는 왜 안생기지
billboard_longer |> 
  ggplot(aes(x = week, y = rank, group = track)) +
  geom_line(alpha = 0.25) +
  scale_y_reverse()

#5.3.2 pivoting 좀 더 해보기. 일단 df를 만들어주고
df <- tribble(
  ~id,  ~bp1, ~bp2,
  "A",  100,  120,
  "B",  140,  115,
  "C",  120,  125
)
#이제 이해가 감. 한 row에 두 개의 column을 배정해야하니 A가 복제되어야하고 그래서 더 길어(longer)지는 것
df |> 
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
  )

#5.3.3 columns에 다양한 variable이 있는 경우. who2 dataset을 쓸 거임. 
#row 이름이 sp/rel/ep + m/f + 나이구간 5개임
#이걸 pivot longer를 하면 각 연도별로 3*2*5, 30개의 row가 복사되겠지.
who2 |> 
  pivot_longer(
    cols = !c(country, year), #country, year가 아닌 cols
    names_to = "year_patients",
    values_to = "counts"
  )
#이렇게 하면 year_patients라는 column이 생기지만 sp_m_1940 뭐 이런 value로 정리 됨. 
#이 정보를 다시 구분하기위해 names_sep을 씀
who2 |> 
  pivot_longer(
    cols = !c(country, year), #country, year가 아닌 cols
    names_to = c("diagnosis", "gender", "age"),
    names_sep = "_",
    values_to = "count"
  )

#names_sep의 대안으로 names_pattern이 있는데 나중에 배울 거임. sep처럼 나누기보다 문자를 뽑아내는 기능 같음

#5.3.4 Data and variable names in the column headers
#다음은 column name이 개복잡한 케이스들임
household |> 
  pivot_longer(
    cols = !family, 
    names_to = c(".value", "child"), 
    names_sep = "_", 
    values_drop_na = TRUE
  )
#이렇게 해주면 된다는데 이해가 안가서 좀 한참 헤맸음
household |> 
  pivot_longer(
    cols = !family,
    names_to = "key",
    values_to = "value"
  )
#이러면 왜 안될까? 내 생각은 아래처럼 됭야하는데. 이건 tibble은 한 column에 한 종류만 들어가야하는데 
#date와 chr이 함께 들어가게 되어서 그렇다고 함.
#1 dob_child1 1998-11-26 
#1 dob_child2 2000-01-29 
#1 name_child1 Susan 
#1 name_child2 Jos

#그래서 .value의 역할을 보면
#names_sep = "_"을 하면 dob, child1 / dob, child2 / name, child1 / name, child2로 나뉘는데 
#names_to는 이 잘려서 나온 각 2개 중 앞에 것은 .value로, 뒤에 것은 child로 column을 명명한다는 뜻임.
#그리고 .value는 잘려 나온 조각 그 자체를 column의 이름으로 사용하라는 뜻이라서 dob와 name column이 생기는 것
#조금 이해가 감..

household |> 
  pivot_longer(
    cols = !family, 
    names_to = c("1", "2"), 
    names_sep = "_", 
    values_drop_na = TRUE
  )
#그러면 이거는 왜 안될까? 역시 이걸하려면 1 column 과 2 column에 날짜와 character가 함께 들어가야하기 때문

#5.4 Widening data
#비슷한데 column을 추가하는 방식의 pivoting임. 실제 사용 빈도는 longer만큼 크진 않다
#사용할 data는 cms_patient_experience, 500*5 data
cms_patient_experience |> 
  distinct(measure_cd, measure_title)
#이걸 해보면 measure code와 title 조합이 6개 뿐임. 요걸 이용할 것
#pivot_longer과 달리 names_from, values_from을 쓴다
cms_patient_experience |> 
  pivot_wider(
    names_from = measure_cd, #measure code 각각의 distinct value들을 wide하게 펼친 것
    values_from = prf_rate
  )
#근데 썩 tidy 하지는 않은데? 이걸 하나로 합쳐야지 ㅇㅇ
cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"), #
    names_from = measure_cd,
    values_from = prf_rate
  )
#많이 나아졌음. id_cols의 기능은 각 행을 구분할 기준이 되는 열을 고르는 것임
#사실 여기서는 org_pac_id가 org_nm이랑 1대1 대응이라 starts_with로 지정하지는 않아도 되지만
#id_cols = org_pac_id로 하면 org_nm이 drop된 결과가 나타난다
#5.4.1 pivot_wider를 실제로 써보자
df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)
#얘를 정리한다고 치면, A의 bp1, bp2, bp3 이렇게 정리하는게 맞겠지
df |> 
  pivot_wider(
    id_cols = id, #id를 기준으로 정렬
    names_from = measurement, #measurement를 새로 생길 column 이름으로 
    values_from = value #value는 value에서 가져온다
  )
#pivot_wider의 underlying function으로 유용한걸 설명해주는데
df |> 
  distinct(measurement) |> 
  pull()
#이렇게 하면 measurement의 unique한 value를 뽑아올 수 있음. 이걸 먼저 하고(여기서는 bp1, bp2, bp3)
df |> 
  select(id) |> 
  distinct()
#이건 id_cols = id에 해당하는 내용. 기준이 될 열의 unique value를 뽑아옴. (여기서는 A, B)
#이걸 바탕으로 2*3 table을 만드는 것임

#Q. 아래처럼 A bp1에 100과 102, 여러 값이 있으면 어떻게 될까?
df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "A",        "bp1",    102,
  "A",        "bp2",    120,
  "B",        "bp1",    140, 
  "B",        "bp2",    115
)
#돌려보면 알지만 output에 list-cols를 포함한다는 경고가 뜬다.
df |>
  pivot_wider(
    names_from = measurement,
    values_from = value
  )
#뻔히 보이지만 누가 문제인지 찾으려면 당연히 이렇게 하면 된다
df |> 
  group_by(id, measurement) |> 
  summarize(n=n(), .groups = "drop") |> 
  filter(n >=2 )

#5.5 summary
#끝