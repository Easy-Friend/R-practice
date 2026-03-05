library(ggplot2)

#2 Workflow
#2.1 basics 간단한 계산, 변수 지정, c로 combine하기, 수열 전체에 사칙연산도 가능, <-는 alt +  - 하면 됨
5/100*20
a <- c(1, 3, 4, 7, 29)
a-1
#2.2 comments는 #쓰면 됨 ㅇㅇ
#2.3 터미널 창에서 위 화살표로 이전 명령 불러오기 가능, 입력 후 tab으로 검색도 가능
#2.4 built-in functions, seq는 수 세기 해줌
a <- seq(from = 2, to = 10) #from과 to는 생략 가능. seq(2, 10) 이렇게
x <- "Hello World"
#Exercises
#1, #2 typo
#3 alt+shift+k 는 shortcut 모음
#4 ggsave(filename = "xxx", plot = nnn) 하면 지정파일 저장 가능
my_bar_plot <- ggplot(mpg, aes(x = class)) +
  geom_bar()
my_scatter_plot <- ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave(filename = "mpg-plot.png", plot = my_bar_plot)