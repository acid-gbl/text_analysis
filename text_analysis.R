install.packages("rJava")
install.packages("jiebaR") 
install.packages("wordcloud2")
install.packages("tm")
library(rJava)
library(jiebaR)
library(wordcloud2)
library(tm)


#停止词
stopwords = unlist(read.table("C:/Users/fan/Desktop/词库/中文停用词库.txt",stringsAsFactors=FALSE))


#移除停止词函数
removestopwords = function(x,stopwords) {
  temp = character(0)
  index = 1
  xLen = length(x)
  while (index <= xLen) {
    if (length(stopwords[stopwords==x[index]]) <1)
      temp = c(temp,x[index])
    index = index +1
  }
  temp
}

#开始分词
data = read.csv("C:/Users/fan/Desktop/2018.7.21/q701.csv",stringsAsFactors=FALSE)
comments = data[,3]
cutter<-worker()
sug<-c("new_words")
new_user_word(cutter,sug)
wordstem = unlist(lapply(comments, segment,cutter))

#删除停止词
words = lapply(wordstem, removestopwords, stopwords)

#统计词频
word = lapply(X=words, strsplit, " ") 
v = table(unlist(word))

# 降序排序  
v = rev(sort(v))

#构建数据框
tf = data.frame(词汇 = names(v), 词频 = as.numeric(v)) 

#筛选大于2个字的词汇
tf_subset = subset(tf, nchar(as.character(tf$词汇))>1 & tf$词频>=10)  

#导出分词数据
write.csv(tf_subset, file="C:/Users/fan/Desktop/2018.7.21/tf_result.csv", row.names = FALSE)


#词云图
mydata = read.csv("C:/Users/fan/Desktop/2018.7.21/tf_result.csv",head=TRUE)
wordcloud2(mydata,  shape = "bird")
