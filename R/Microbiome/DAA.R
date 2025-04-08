set.seed(1)                                      
ZicoSeq.obj <- ZicoSeq(meta.dat = clin_meta_LC, feature.dat = comm_s_LC, 
                         grp.name = 'study_group', feature.dat.type = "count",
                         prev.filter = 0.1, mean.abund.filter = 0.0001,  
                       adj.name = c("age", "sex"),
                       max.abund.filter = 0.002, min.prop = 0, 
		is.winsor = TRUE, outlier.pct = 0.03, winsor.end = 'top',
		is.post.sample = TRUE, post.sample.no = 25, 
	  link.func = list(function (x) x^0.5),
		stats.combine.func = max,
		perm.no = 999,  strata = NULL, 
		ref.pct = 0.5, stage.no = 6, excl.pct = 0.2,
		is.fwer = FALSE,
		verbose = TRUE, return.feature.dat = T)
