import { defineConfig } from "vitepress";

export default defineConfig({
  srcDir: "src",
  base: "/typed/",

  title: "typed",
  description: "luau runtime type validation library",
  themeConfig: {
    nav: [{ text: "docs", link: "/docs/introduction/what-is-typed" }],

    sidebar: [
      {
        text: "introduction",
        items: [
          {
            text: "what is typed",
            link: "/docs/introduction/what-is-typed",
          },
          {
            text: "getting started",
            link: "/docs/introduction/getting-started",
          },
        ],
      },
      {
        text: "guide",
        items: [
          {
            text: "schemas",
            link: "/docs/guide/schemas",
          },
          {
            text: "modifiers",
            link: "/docs/guide/modifiers",
          },
          {
            text: "combinators",
            link: "/docs/guide/combinators",
          },
        ],
      },
    ],

    socialLinks: [
      { icon: "github", link: "https://github.com/metamethods/typed" },
    ],
  },
});
