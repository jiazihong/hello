#import "@local/modern-cug-report:0.1.3": *
#show: doc => template(doc, footer: "水文气象学", header: "")
== 运行示例

在 R 控制台中用 `setwd()` 切换到包含 `DESCRIPTION` 的项目根目录，然后加载项目。

```r
pkgload::load_all(".")
```

加载成功后，即可运行下方的函数示例。

= Component 函数说明

== RemoveSeasonal

`y` 是观测值，`t_mmdd` 是对应的月日编码。
函数按月日计算平均值 `mu`，并返回每个观测值减去当天平均值后的距平 `anomaly`。

```r
RemoveSeasonal(c(10, 14, 20, 24), c(101, 101, 102, 102))
```

这个例子返回的均值是 `(12, 22)`，距平是 `(-2, 2, -2, 2)`。



== LS_OneBreak

拟合一个已知断点的分段线性回归。两段共用一个斜率，各有自己的截距。
`Y` 是观测值，`X` 是自变量，`Ic` 是第一段最后一个观测的位置。
例如 `Ic = 3` 表示第 1 到第 3 个点属于第一段，第 4 个点起属于第二段。

```r
fit <- LS_OneBreak(
  Y = c(2, 4, 6, 18, 20, 22),
  X = 1:6,
  Ic = 3
)
fit$fitted
```

这组数据的拟合值为 `(2, 4, 6, 18, 20, 22)`。

== LS_MultiBreaks

拟合有多个已知断点的分段线性回归。所有分段共用一个斜率，各有自己的截距。
`Ips` 列出每一段的结束位置，最后一个数等于观测总数。
例如 `c(3, 6, 9)` 把 9 个点分成第 1 到 3、第 4 到 6、第 7 到 9 三段。

```r
fit <- LS_MultiBreaks(
  Y = c(2, 4, 6, 18, 20, 22, 18, 20, 22),
  X = 1:9,
  Ips = c(3, 6, 9)
)
fit$fitted
```

这组数据的拟合值为 `(2, 4, 6, 18, 20, 22, 18, 20, 22)`。

== lm_solve

这是前面两个回归函数调用的最小二乘辅助函数。
`design` 是设计矩阵，`response` 是对应的观测值。
默认返回回归系数 `coef`、拟合值 `fitted`、残差 `resi` 和残差平方和 `SSE`。
设置 `only.SSE = TRUE` 时，只返回 `SSE`。

```r
fit <- lm_solve(
  design = cbind(1, 1:4),
  response = c(3, 5, 7, 9)
)
fit$coef
```

这个例子的截距是 `1`，斜率是 `2`。
