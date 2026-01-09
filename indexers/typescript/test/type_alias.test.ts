import { expect, test } from "vitest";
import { execute } from "./utils";

test("basic type", () => {
  let res = execute(`export type Foo = string;`);

  expect(res["test_package/index.ts/Foo"].grammar).toEqual({
    name: "Foo",
    type: "string",
    signature: "type Foo = string;",
  });
});

test("function type", () => {
  let res = execute(`export type Foo = (a: string, b: int) => string;`);

  expect(res["test_package/index.ts/Foo"].grammar).toEqual({
    name: "Foo",
    type: {
      kind: "function",
      parameters: {
        named: [],
        positional: [
          { required: true, name: "a", type: "string" },
          { required: true, name: "b", type: "int" },
        ],
      },
      return_type: "string",
    },
    signature: "type Foo = (a: string, b: int) => string;",
  });
});

test("object type", () => {
  let res = execute(`
    export type Foo = {
      prim: string;
      unio: number | undefined;
      opti?: number;
      readonly read: number;

      arFn: (a: number) => int;
      func: (a: number) => int;
    };
  `);

  expect(res["test_package/index.ts/Foo"].grammar).toEqual({
    name: "Foo",
    type: {
      kind: "object",
      members: {
        prim: { required: true, readonly: false, type: "string" },
        unio: { required: true, readonly: false, type: "number | undefined" },
        opti: { required: false, readonly: false, type: "number" },
        read: { required: true, readonly: true, type: "number" },
        arFn: { required: true, readonly: false, type: "(a: number) => int" },
        func: { required: true, readonly: false, type: "(a: number) => int" },
      },
    },
    signature:
      "type Foo = { prim: string; unio: number | undefined; opti?: number; readonly read: number; arFn: (a: number) => int; func: (a: number) => int; };",
  });
});
