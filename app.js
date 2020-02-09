const interval = 60 * 1000

const colors = [
  ['#f8f9fa', '#f1f3f5', '#e9ecef', '#dee2e6', '#ced4da', '#adb5bd', '#868e96', '#495057', '#343a40', '#212529'], // Gray
  ['#fff5f5', '#ffe3e3', '#ffc9c9', '#ffa8a8', '#ff8787', '#ff6b6b', '#fa5252', '#f03e3e', '#e03131', '#c92a2a'], // Red
  ['#fff0f6', '#ffdeeb', '#fcc2d7', '#faa2c1', '#f783ac', '#f06595', '#e64980', '#d6336c', '#c2255c', '#a61e4d'], // Pink
  ['#f8f0fc', '#f3d9fa', '#eebefa', '#e599f7', '#da77f2', '#cc5de8', '#be4bdb', '#ae3ec9', '#9c36b5', '#862e9c'], // Grape
  ['#f3f0ff', '#e5dbff', '#d0bfff', '#b197fc', '#9775fa', '#845ef7', '#7950f2', '#7048e8', '#6741d9', '#5f3dc4'], // Violet
  ['#edf2ff', '#dbe4ff', '#bac8ff', '#91a7ff', '#748ffc', '#5c7cfa', '#4c6ef5', '#4263eb', '#3b5bdb', '#364fc7'], // Indigo
  ['#e7f5ff', '#d0ebff', '#a5d8ff', '#74c0fc', '#4dabf7', '#339af0', '#228be6', '#1c7ed6', '#1971c2', '#1864ab'], // Blue
  ['#e3fafc', '#c5f6fa', '#99e9f2', '#66d9e8', '#3bc9db', '#22b8cf', '#15aabf', '#1098ad', '#0c8599', '#0b7285'], // Cyan
  ['#e6fcf5', '#c3fae8', '#96f2d7', '#63e6be', '#38d9a9', '#20c997', '#12b886', '#0ca678', '#099268', '#087f5b'], // Teal
  ['#ebfbee', '#d3f9d8', '#b2f2bb', '#8ce99a', '#69db7c', '#51cf66', '#40c057', '#37b24d', '#2f9e44', '#2b8a3e'], // Green
  ['#f4fce3', '#e9fac8', '#d8f5a2', '#c0eb75', '#a9e34b', '#94d82d', '#82c91e', '#74b816', '#66a80f', '#5c940d'], // Lime
  ['#fff9db', '#fff3bf', '#ffec99', '#ffe066', '#ffd43b', '#fcc419', '#fab005', '#f59f00', '#f08c00', '#e67700'], // Yellow
  ['#fff4e6', '#ffe8cc', '#ffd8a8', '#ffc078', '#ffa94d', '#ff922b', '#fd7e14', '#f76707', '#e8590c', '#d9480f'] // Orange
]

const logoWrapper = document.querySelector('.logo')
const logoColor = logoWrapper.querySelector('g > path')

const typeLength = colors.length
const levelLength = colors[0].length

const setLogoColor = (type, level) => {
  logoColor.style.fill = colors[type][level]
  console.log(
    `%cOC- %c ${type} %c %c ${level} %c → %c  `,
    `color: ${colors[0][7]}`,
    `border-radius: 4px; background: ${colors[type][7]}`,
    '',
    `border-radius: 4px; background: ${colors[0][level]}`,
    '',
    `border-radius: 4px; background: ${colors[type][level]}`
  )
}

setLogoColor(
  ~~(Date.now() / interval) % typeLength,
  ~~(Date.now() / (interval / levelLength)) % levelLength
)

logoWrapper.onclick = () => setLogoColor(
  ~~(Math.random() * typeLength),
  ~~(Math.random() * levelLength)
)

// ----------------------------------------

const quality = 0.5

const width = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth
const height = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight

const url = `https://source.unsplash.com/random/${width * quality}x${height * quality}`

const background = document.querySelector('.background')
const svg = background.querySelector('svg')
const img = document.createElement('img')
background.appendChild(img)

fetch(url).then(res => res.blob()).then(blob => {
  img.src = URL.createObjectURL(blob)
  svg.remove()
  // next tick
  // setTimeout(() => svg.remove(), 0)
})
