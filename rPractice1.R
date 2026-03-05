library(tidyverse)
library(palmerpenguins)
library(ggthemes)

#1.2
#ggplot의 형식, 처음은 data를 지정, mapping = aes(aesthetic)라는 function으로 x축과 y축을 지정함
#geom_point 는 scattered plot을, geom_bar(), geom_boxplot(), geom_line() 등이 있음
#species라는 categorical variable을 aes에 추가하면 자동으로 level을 labelling해서 오른쪽에 표시해줌.
#이 과정을 scaling이라고 함
ggplot(
  data = penguins, 
  mapping = aes(x = flipper_len, y= body_mass_g)
  ) +
  geom_point(mapping = aes(color = species, shape = species)) +
#이 다음은 새로운 geometrical object를 추가할 건데 각 산도표의 best fit line을 긋고자 함. lm = linear model
  geom_smooth(method = "lm") + 
#다음은 labelling임
  labs(
    title = "제목ㅇㅇ",
    subtitle = "ㅇㅇ하고싶은거해라", 
    x = "Flipper Length (mm)",
    y = "Body Mass (g)",
    color = "Species",
    shape = "Species" #만약 legend를 같은 이름으로 지정안하면 legend가 두 개로 나옴
  ) +
  scale_color_colorblind()

#1.2Exercises
#1 터미널 스크립트에 ?penguins 입력해서 답 알기 344 rows and 8 variables
#2 마찬가지. bill depth임
#3 bill depth와 bill length 관계 scatterplot으로 표시하기. 후자를 x축으로
ggplot(
  data = penguins,
  mapping = aes(x = bill_length_mm, y = bill_depth_mm)
) + 
  geom_point()
#4 species vs bill_depth_mm 로 바꿔보기 ㅇㅇ바꿈
#5 x축과 y 축을 입력해줘야한다
#6 geom_point에서 na.rm 이 뭘 하는가. geom_point F1누르면 나오는데 default는 FALSE임
#의미는 missing value를 warning을 하고 지워준다는 것. TRUE로 하면 warning 안뜬다
ggplot(
  data = penguins,
  mapping = aes(x = bill_length_mm, y = bill_depth_mm)
) + 
  geom_point(na.rm = TRUE)
#7 labs를 참고해서 caption을 추가해봐라
ggplot(
  data = penguins,
  mapping = aes(x = bill_length_mm, y = bill_depth_mm)
) +
  geom_point() +
  labs(
    title = "예제",
    subtitle = "예제예제",
    caption = "하고싶은 말을 여기에 쓰면 되는 것"
  )
#8 아까처럼 body mass 와 flipper length 를 비교하는데 species 말고 bill_depth_mmth로 색을 표시해봐라. 
#추가로 best fit smooth line 도 하나 그을 거니까 global로 mapping 할지 local로 할지도 정하기
ggplot(
  data = penguins,
  mapping = aes(x = flipper_len, y = body_mass_g)
) +
  geom_point(mapping = aes(color = bill_depth_mm)) +
  geom_smooth() + 
  labs(
    title = "ㅇㅇ",
    subtitle = "ㅇㅇ2", 
    x= "Flipper Length (mm)",
    y = "Body Mass (g)",
    color = "Bill Depth (mm)"
  )

#9 아래 코드 plot 예상해보기
ggplot(
  data = penguins,
  mapping = aes(x = flipper_len, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE)

#10 아래 두 코드가 같을지 다를지 예상하기 - 당연히 같다 
ggplot(
  data = penguins,
  mapping = aes(x = flipper_len, y = body_mass_g)
) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(
    data = penguins,
    mapping = aes(x = flipper_len, y = body_mass_g)
  ) +
  geom_smooth(
    data = penguins,
    mapping = aes(x = flipper_len, y = body_mass_g)
  )

#1.3 ggplot()의 첫 두 argument는 무조건 data, mapping 이기 때문에 생략 가능함 즉, 
ggplot(penguins, aes(x = flipper_len, y = body_mass_g)) +
  geom_point() #라고 해도 같다는 뜻. 혹은 pipe를 통해
penguins|>
  ggplot(aes(x = flipper_len, y = body_mass_g)) +
  geom_point() #도 같은 결과가 나옴

#1.4 visualizing distributions
ggplot(penguins, aes(x = species)) +
  geom_bar() #Q geom_point로 하면 y축이 비었다고 하는데 bar로 하면 자동으로 갯수 세주네..
#순서를 정리할 수 도 있음. factor in frequency, factor in sequence는 level의 numeric value 순으로 정리함ㅇㅇ
ggplot(penguins, aes(x=fct_infreq(species))) + 
  geom_bar()
#그 다음은 numerical variable을 구간화해서 categorize 하는 것
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200) 
#혹은 geom_density()를 쓰면 smooth 한 곡선 표현 가능임
ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

#1.4Exercises
#1 y에 species를 넣어보면? ㅇㅇ 걍 세로로 나옴
ggplot(penguins, aes(y=species))  +
  geom_bar()
#2 전자는 bar의 테두리만 빨갛게 해줌. 후자가 생각하는 그것임
ggplot(penguins, aes(x = species)) +
  geom_bar(color = "red")

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red")
#3 bins의 기능은? 몇개로 구간을 나눌 것인가임. default는 30
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(bins = 40) 

#4 diamonds data로 carat histogram을 만들어보세요. 0.1이 적당한듯
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

#1.5 variable 사이의 관계 표시
#1.5.1 categorical과 numerical
#box plot 주식창같은 그거임. 25-75% 를 박스권, 50%에 선긋고 위아래 꼬리. outlier는 점으로
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()
#density chart도 있음
ggplot(penguins, aes(x = body_mass_g, color = species)) +
  geom_density(linewidth = 0.75)
#혹은 이렇게 채울 수도
ggplot(penguins, aes(x=body_mass_g, color = species, fill = species)) +
  geom_density(alpha = 0.3)

#1.5.2 categorical & categorical
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()
#비율을 보고싶다면
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill") +
  labs(y = "proportion")

#1.5.3 two numerical variables - 그냥 산도표
#1.5.4 three numerical variables 는 color 씌우는 것 처럼 하면 되긴하는데
#그렇게 하면 가독성이 떨어지니 따로 끊어서 보여주는 것이 낫다 이걸 facet wrapping이라 함 
ggplot(penguins, aes(x = flipper_len, y = body_mass_g)) +
  geom_point(aes(colour = species, shape = species)) +
  facet_wrap(vars(island)) #vars(island)랑 ~island랑 같나봄 

#1.5.5 Exercises
#1 mpg data의 variable categorical 인지 알아보기. ?mpg
#2 mpg로 displ vs hwy로 scatter plot 만들어보기, 추가 numerical로 엮기. 
#color size는 되지만 shape은 numerical 안되네 당연함. 모양은 연속적이지 않으니
mpg |>
  ggplot(aes(x = displ, y = hwy, color = cty, size = cty)) +
  geom_point()
#3 3rd variable을 linewidth로 하면 무슨 일이 생기나. 아무 일도 안생기는데
mpg |>
  ggplot(aes(x = displ, y = hwy, linewidth = cty)) +
  geom_point()
#4 한 variable에 multiple aesthetics를 넣으면? 그냥 둘 다 적용이지뭐..
#5 penguins로 돌아가서 bill depth랑 bill length로 scatterplot 만들고 species로 색칠. 
#그러면 뭐가 달라지는지랑 facet도 해라 
penguins |>
  ggplot(aes(x = bill_depth_mm, y = bill_length_mm, color = species)) +
  geom_point() +
  facet_wrap(~species)

#6부터 보기. 왜 legend가 두 개 생기냐? 내가 이미 한 것이네 color shape species랑 같게 해줘야지
ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm, 
    color = species, shape = species
  )
) +
  geom_point() +
  labs(color = "Species")

#7 이건 뭐 각 섬의 펭귄 분포 vs 각 펭귄의 서식지 확인

#1.6 저장하기
ggsave(filename = "one.png") # 현재 plot창에 띄워져있는 하나만 저장 되는 듯.
#Exercises 아 여기서 가르쳐주네 마지막 꺼 기준으로 저장 됨
ggplot(mpg, aes(x = class)) +
  geom_bar()
ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave("mpg-plot.pdf")

#오케이 끝