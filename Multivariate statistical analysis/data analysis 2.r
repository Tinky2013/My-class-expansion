# 数据导入
library(openxlsx)
df=read.xlsx("C:/Users/Tinky/Desktop/sample.xlsx",2)
# 数据探索
df<-df[-1,] # 删去中文解释行
df_na<-apply(is.na(df), 2, sum) # 统计每列的缺失值

# 每列单独拿出分析异常值
df_age=apply(na.omit(df['age']),2,as.numeric)
df_blood=apply(na.omit(df[,4:5]),2,as.numeric)                
df_smoke=na.omit(df['smoke'])
df_drunk=na.omit(df['drunk'])
df_FPG=apply(df['FPG'],2,as.numeric)
df_TG=apply(df['TG'],2,as.numeric)
df_HDL_C=apply(df['HDL-C'],2,as.numeric)
df_hw=na.omit(df[,6:7])
df_hw=apply(df_hw,2,as.numeric)

# 通过画图来监测异常值
boxplot(df_age)
plot(df_blood)
plot(df_hw)
boxplot(df_HDL_C)

# 通过数据分析得出的异常值处理方案：
# 去掉HDL_C小于1的
# 去掉weight大于120的
# 去掉age小于20的
# 向量X中去掉所有空值的行

# 数据预处理
df[,c(3:7,10:12)]=(lapply(df[,c(3:7,10:12)],as.numeric)) # 转换为数值
# 如果数据缺失weight、age，将本行删去
df=df[(complete.cases(df['weight'])),]
df=df[(complete.cases(df['age'])),]
df=df[(df['weight']<120 & df['age']>20),] # 除去异常值
apply(is.na(df), 2, sum)  # 检查数据缺失情况（现在只有smoke和drunk两列有缺失值）

# 构造向量X
X<-cbind(df[6:7],df[10],df[4:5],df[11:12])
bmi=X[,1]/(X[,2]/100)^2
bmi=as.matrix(bmi)
X=as.matrix(X[,3:7])
X<-cbind(bmi,X) 
colnames(X)<-c("BMI","FPG","sbp","dbp","TG","HDL-C")

# (1)变量间的相关性分析
res<-cor(value)
library(corrplot)
corrplot(res)

# (4)计算数字特征
colMeans(X) # 样本均值
# result:
# BMI 23.7365627869242
# FPG 5.56296296296296
# sbp 118.658436213992
# dbp 75.9670781893004
# TG 1.94674897119342
# HDL-C 1.61028806584362
var(X)*(nrow(X)-1)  # 样本离差阵
# result:
# 	    BMI	      FPG	        sbp	        dbp	      TG	    HDL-C
# BMI	2715.3220	236.37801	4600.65401	3534.3029	485.92699	-96.64010
# FPG	236.3780	232.49547	802.03593	744.5737	140.79784	-16.48121
# sbp	4600.6540	802.03593	69430.65021	37595.2675	1184.40016	-94.77609
# dbp	3534.3029	744.57370	37595.26749	31527.7366	1329.33399	-114.84770
# TG	485.9270	140.79784	1184.40016	1329.3340	558.64273	-42.02027
# HDL-C	-96.6401	-16.48121	-94.77609	-114.8477	-42.02027	28.13188
var(X)  # 样本协方差阵
# result:
#       BMI	      FPG	        sbp	        dbp	        TG	        HDL-C
# BMI	11.2203390	0.97676862	19.0109670	14.6045573	2.0079628	-0.39933927
# FPG	0.9767686	0.96072507	3.3141980	3.0767508	0.5818093	-0.06810416
# sbp	19.0109670	3.31419804	286.9035132	155.3523450	4.8942156	-0.39163674
# dbp	14.6045573	3.07675084	155.3523450	130.2799034	5.4931157	-0.47457725
# TG	2.0079628	0.58180926	4.8942156	5.4931157	2.3084410	-0.17363749
# HDL-C	-0.3993393	-0.06810416	-0.3916367	-0.4745773	-0.1736375	0.11624744
cor(X)  # 样本相关阵
# result：
# 	  BMI	      FPG	      sbp	        dbp	        TG	      HDL-C
# BMI	1.0000000	0.2975015	0.33506826	0.3819853	0.3945420	-0.34966111
# FPG	0.2975015	1.0000000	0.19962318	0.2750135	0.3906804	-0.20378978
# sbp	0.3350683	0.1996232	1.00000000	0.8035468	0.1901760	-0.06781469
# dbp	0.3819853	0.2750135	0.80354678	1.0000000	0.3167529	-0.12194851
# TG	0.3945420	0.3906804	0.19017603	0.3167529	1.0000000	-0.33519105
# HDL-C	-0.3496611	-0.2037898	-0.06781469	-0.1219485	-0.3351910	1.00000000


# (5)是否服从正态分布
ks.test(X[,2], "pnorm", mean = mean(X[,2]), sd =  sqrt(X[,2]))
# result:
# data:  X[, 2]
# D = 0.34453, p-value < 2.2e-16
# alternative hypothesis: two-sided
ks.test(X[,3], "pnorm", mean = mean(X[,3]), sd =  sqrt(X[,3]))
# result:
# data:  X[, 3]
# D = 0.14276, p-value = 9.992e-05
# alternative hypothesis: two-sided
# D值较大，p值很小，不符合正态分布

# (3)年龄上的差异
df3=df  # df3中年龄为分类变量
df3[df3[,'age']>70,'age']<-'>70'
df3[(df3[,'age']>50 & df3[,'age']<=70),'age']<-'50-70'
df3[(df3[,'age']>30 & df3[,'age']<=50),'age']<-'30-50'
df3[(df3[,'age']<=30),'age']<-'<=30'
# 按照年龄段为分类变量绘制箱型图
f<-factor(df3[,'age'])
dfp<-data.frame(df3,f)
boxplot(as.numeric(df3[,'BMI'])~f,dfp)
boxplot(as.numeric(df3[,'FPG'])~f,dfp)
boxplot(as.numeric(df3[,'TG'])~f,dfp)
boxplot(as.numeric(df3[,'HDL-C'])~f,dfp)
# sbp/dbp散点图
library(ggplot2)
ggplot(data.frame(df3), aes(sbp,dbp, colour=age)) + geom_point()#以颜色区分

# (2)代谢综合征
df2<-df
new<-matrix(FALSE,nrow(df2),1)
df2<-cbind(df2,new)
colnames(df2)<-c("BMI","No","gender","age","sbp","dbp","weight","height","smoke","drunk","FPG","TG","HDL-C","syn")
# 添加一列描述是否有代谢综合症
cond<-function(x){
    i=0
    if(as.numeric(x['BMI'])>=25.0) i=i+1
    if(as.numeric(x['FPG'])>=6.1) i=i+1
    if(as.numeric(x['sbp'])>=140||as.numeric(x['dbp'])>=90) i=i+1
    if(as.numeric(x['TG'])>=1.7||((as.numeric(x['HDL-C'])<0.9&&x['gender']=='男')||(as.numeric(x['HDL-C'])<1&&x['gender']=='女'))) i=i+1
    
    if(i>=3) return(TRUE)
    else return(FALSE)
}
for(i in 1:nrow(df2)){
    if(cond(df2[i,])){
        df2[i,'syn']=TRUE
    }
}

# 综合征与性别/抽烟/饮酒的关系
male_synT<-nrow(df2[(df2[,'gender']=='男')&(df2[,'syn']==TRUE),])
male_synF<-nrow(df2[(df2[,'gender']=='男')&(df2[,'syn']==FALSE),])
female_synT<-nrow(df2[(df2[,'gender']=='女')&(df2[,'syn']==TRUE),])
female_synF<-nrow(df2[(df2[,'gender']=='女')&(df2[,'syn']==FALSE),])
cat("男性患者总数：",male_synT,"  男性非患者总数：",male_synF,"  男性患病率：",male_synT/(male_synT+male_synF),"\n")
cat("女性患者总数：",female_synT,"  女性非患者总数：",female_synF,"  女性患病率：",female_synT/(female_synT+female_synF),"\n")
# result:
# 男性患者总数： 28   男性非患者总数： 129   男性患病率： 0.1783439 
# 女性患者总数： 2   女性非患者总数： 84   女性患病率： 0.02325581 

smokeT_synT<-nrow(df2[(df2[,'smoke']=='是')&(df2[,'syn']==TRUE),])
smokeT_synF<-nrow(df2[(df2[,'smoke']=='是')&(df2[,'syn']==FALSE),])
smokeF_synT<-nrow(df2[(df2[,'smoke']=='否')&(df2[,'syn']==TRUE),])
smokeF_synF<-nrow(df2[(df2[,'smoke']=='否')&(df2[,'syn']==FALSE),])
cat("吸烟患者总数：",smokeT_synT,"  吸烟非患者总数：",smokeT_synF,"  吸烟患病率：",smokeT_synT/(smokeT_synT+smokeT_synF),"\n")
cat("不吸烟患者总数：",smokeF_synT,"  不吸烟非患者总数：",smokeF_synF,"  不吸烟患病率：",smokeF_synT/(smokeF_synT+smokeF_synF),"\n")
# result:
# 吸烟患者总数： 18   吸烟非患者总数： 98   吸烟患病率： 0.1551724 
# 不吸烟患者总数： 16   不吸烟非患者总数： 163   不吸烟患病率： 0.08938547 

drunkT_synT<-nrow(df2[(df2[,'drunk']=='是')&(df2[,'syn']==TRUE),])
drunkT_synF<-nrow(df2[(df2[,'drunk']=='是')&(df2[,'syn']==FALSE),])
drunkF_synT<-nrow(df2[(df2[,'drunk']=='无')&(df2[,'syn']==TRUE),])
drunkF_synF<-nrow(df2[(df2[,'drunk']=='无')&(df2[,'syn']==FALSE),])
cat("饮酒患者总数：",drunkT_synT,"  饮酒非患者总数：",drunkT_synF,"  饮酒患病率：",drunkT_synT/(drunkT_synT+drunkT_synF),"\n")
cat("不饮酒患者总数：",drunkF_synT,"  不饮酒非患者总数：",drunkF_synF,"  不饮酒患病率：",drunkF_synT/(drunkF_synT+drunkF_synF),"\n")
# result:
# 饮酒患者总数： 22   饮酒非患者总数： 109   饮酒患病率： 0.1679389 
# 不饮酒患者总数： 12   不饮酒非患者总数： 145   不饮酒患病率： 0.07643312 
