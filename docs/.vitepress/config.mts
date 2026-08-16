import { defineConfig } from "vitepress";

export default defineConfig({
  srcDir: "./",
  base: "/typed/",

  title: "typed",
  description: "Luau runtime type validation library",
  themeConfig: {
    nav: [{ text: "docs", link: "/introduction/what-is-typed" }],

    sidebar: [
      {
        text: "Introduction",
        items: [
          {
            text: "What is Typed",
            link: "/introduction/what-is-typed",
          },
          {
            text: "Getting Started",
            link: "/introduction/getting-started",
          },
        ],
      },
      {
        text: "Guide",
        items: [
          {
            text: "Schemas",
            link: "/guide/schemas",
          },
          {
            text: "Modifiers",
            link: "/guide/modifiers",
          },
          {
            text: "Combinators",
            link: "/guide/combinators",
          },
        ],
      },
    ],

    socialLinks: [
      { icon: "github", link: "https://github.com/metamethods/typed" },
    ],
  },
});
