import { defineConfig } from "vitepress";

export default defineConfig({
  srcDir: "./",
  base: "/typed/",

  title: "typed",
  description: "Luau runtime type validation library",
  themeConfig: {
    outline: "deep",

    nav: [
      {
        text: "Docs",
        link: "/docs/introduction/what-is-typed",
      },
      {
        text: "API",
        link: "/api/schema",
      },
    ],

    sidebar: {
      "/docs/": [
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
              text: "Writing Schemas",
              link: "/docs/guide/writing-schemas",
            },
          ],
        },
      ],
      "/api/": [
        {
          text: "Schema",
          link: "/api/schema",
        },
      ],
    },

    socialLinks: [
      { icon: "github", link: "https://github.com/metamethods/typed" },
    ],
  },
});
