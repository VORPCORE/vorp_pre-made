exports('checkRegex', (regex, str) => {
    let rgx = new RegExp(regex)
    return rgx.test(str)
})