module.exports = {
    plugins: [
    require("postcss-import"),
    require("postcss-url")("inline"),
    require("tailwindcss")("./tailwind.config.js"),
    require('postcss-nested'),
    require('autoprefixer'),
    require('cssnano')("default")
    ]
}