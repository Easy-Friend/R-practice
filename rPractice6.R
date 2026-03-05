#6 Workflow: scripts and projects
#지금하고있긴한데 scripts를 써라
#scripts에서는 ctrl+enter를 하면 실행할 수 있음. 한 문단씩 실행되는 듯? 문단 중간에 커서가 있어도 되고.
#모든 변수가 environment 없이도 돌아가야하니 option에서 workspace restore 하는 옵션 꺼라
#Ctrl + shift + F10은 R 재시작임 
#아래 칸에 console tab을 보면 현재 working directory를 확인할 수 있음. 아니면
getwd()
#이렇게 볼 수도 있다
#setwd(oo/oo/oo/) 이 방식으로 지정할 수도 있지만 저자들은 이 방식을 추천하지는 않고 Rstudio Project를 사용하라함
library(tidyverse)

ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_hex()
ggsave("diamonds.png")

write_csv(diamonds, "diamonds.csv")
#이런 식으로 만들어주면 되고 Rproject를 켜면 environment는 비어있어도 다시 돌아오게 된다.
