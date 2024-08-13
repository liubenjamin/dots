// ~/.finicky.js

module.exports = {
  defaultBrowser: "Firefox",
  handlers: [
    {
      match: [
        "*.google.com/*",
      ],
      browser: "Google Chrome"
    }
  ]
};
