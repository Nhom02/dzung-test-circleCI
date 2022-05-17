// Prepare folder structure
// eslint-disable-next-line @typescript-eslint/no-var-requires
const path = require('path')
// eslint-disable-next-line @typescript-eslint/no-var-requires
const fs = require('fs-extra')
// eslint-disable-next-line @typescript-eslint/no-var-requires
const chalk = require('chalk')

const dir = path.join(process.cwd(), 'e2e/cucumber-report')

if (fs.existsSync(dir)) {
  fs.removeSync(dir)
}

fs.mkdirSync(dir)

const months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
]
const currentDate = new Date()
const year = currentDate.getFullYear()
const monthIndex = currentDate.getMonth()
const monthName = months[monthIndex]
const date = currentDate.getDate()
const timeEnd = `${date} ${monthName} ${year}`

// eslint-disable-next-line @typescript-eslint/no-var-requires
const reporter = require('multiple-cucumber-html-reporter')
const options = {
  pageTitle: 'Yojee automation',
  jsonDir: path.join(process.cwd(), 'e2e/cucumber-json'),
  reportPath: 'e2e/cucumber-report/html',
  hideMetadata: false,
  metadata: {
    app: {
      name: 'membersApp',
      version: '1.0.0',
    },   
    device: 'iPhone 12 Pro',
    platform: {
      name: 'iOS',
      version: '14.5',
    },
  },
  customData: {
    title: 'YOJEE MOBILE AUTOMATION TESTING',
    data: [
      { label: 'Project', value: 'YOJEE-EXPLORE' },
      { label: 'Run end:', value: timeEnd },
      { label: 'Framework', value: 'Detox' },
    ],
  },
  displayDuration: true,
  durationInMS: false,
  displayReportTime: true,
}

// Generate report
try {
  reporter.generate(options)
} catch (e) {
  console.log(chalk.red(`Could not generate cypress reports`))
  console.log(chalk.red(`${e}`))
}
