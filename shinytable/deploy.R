## Copy data
system('cp ../cross_studies_metadata/recount_brain_v2.csv .')

library('rsconnect')
load('.deploy_info.Rdata')
rsconnect::setAccountInfo(name=deploy_info$name, token=deploy_info$token,
    secret=deploy_info$secret)
deployApp(appFiles = c('ui.R', 'server.R', 'recount_brain_v2.csv'),
    appName = 'recount-brain', account = deploy_info$name)

deployApp(appFiles = c('ui.R', 'server.R', 'DESCRIPTION', 'recount_brain_v2.csv'),
    appName = 'recount-brain-showcase', account = deploy_info$name)
