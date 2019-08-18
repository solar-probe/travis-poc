module.exports = {
  getResponse: () => {
    return {
      myapplication: [
        {
          version: '1.0',
          lastcommitsha: process.env.ENV_COMMIT_SHA,
          description: 'https://www.nasa.gov/content/goddard/parker-solar-probe-videos'
        }
      ]
    }
  }
}
