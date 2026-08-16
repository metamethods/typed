import { defineConfig } from "vitepress";

export default defineConfig({
  srcDir: "src",
  base: "/typed/",

  title: "typed",
  description: "Luau runtime type validation library",
  themeConfig: {
    nav: [{ text: "docs", link: "/docs/introduction/what-is-typed" }],

    sidebar: [
      {
        text: "Introduction",
        items: [
          {
            text: "What is Typed",
            link: "/docs/introduction/what-is-typed",
          },
          {
            text: "Getting Started",
            link: "/docs/introduction/getting-started",
          },
        ],
      },
      {
        text: "Guide",
        items: [
          {
            text: "Schemas",
            link: "/docs/guide/schemas",
          },
          {
            text: "Modifiers",
            link: "/docs/guide/modifiers",
          },
          {
            text: "Combinators",
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
