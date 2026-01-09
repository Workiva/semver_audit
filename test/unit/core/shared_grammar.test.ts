import { test, expect, describe } from 'vitest';
import { visitParameters } from '../../../src/core/shared_grammar';
import { Semver } from '../../../src/core/models';

describe('visitParameters', () => {
  test('adding a "required: false" named parameter is a minor', () => {
    expect(
      visitParameters(
        { named: [], positional: [] },
        {
          named: [{ type: 'int', required: false, name: 'foo' }],
          positional: [],
        },
      ),
    ).toEqual([Semver.minor("Adding the optional parameter 'foo' is a minor")]);
  });
  test('adding a "required: true" named parameter is a major', () => {
    expect(
      visitParameters(
        { named: [], positional: [] },
        {
          named: [{ type: 'int', required: true, name: 'foo' }],
          positional: [],
        },
      ),
    ).toEqual([Semver.major("Adding the required parameter 'foo' is a major")]);
  });

  test('adding a "required: false" positional parameter to the end of the list is a minor', () => {
    expect(
      visitParameters(
        {
          named: [],
          positional: [{ type: 'String', required: true, name: 'foo' }],
        },
        {
          named: [],
          positional: [
            { type: 'String', required: true, name: 'foo' },
            { type: 'int', required: false, name: 'bar' },
          ],
        },
      ),
    ).toEqual([Semver.minor("Adding the optional parameter 'bar' is a minor")]);
  });
  test('adding a "required: false" positional parameter not at the end of the list is a major', () => {
    expect(
      visitParameters(
        {
          named: [],
          positional: [{ type: 'String', required: true, name: 'foo' }],
        },
        {
          named: [],
          positional: [
            { type: 'int', required: true, name: 'bar' },
            { type: 'String', required: true, name: 'foo' },
          ],
        },
      ),
    ).toEqual([
      Semver.major("Changing the type of the parameter 'foo' is a major"),
      Semver.major("Adding the required parameter 'foo' is a major"),
    ]);
  });
  test('adding a "required: true" positional parameter to the end of the list is a major', () => {
    expect(
      visitParameters(
        {
          named: [],
          positional: [{ type: 'String', required: true, name: 'foo' }],
        },
        {
          named: [],
          positional: [
            { type: 'String', required: true, name: 'foo' },
            { type: 'int', required: true, name: 'bar' },
          ],
        },
      ),
    ).toEqual([Semver.major("Adding the required parameter 'bar' is a major")]);
  });

  test('changing a named parameter from optional to required is a major', () => {
    expect(
      visitParameters(
        {
          named: [{ type: 'int', required: false, name: 'foo' }],
          positional: [],
        },
        {
          named: [{ type: 'int', required: true, name: 'foo' }],
          positional: [],
        },
      ),
    ).toEqual([
      Semver.major("Making the named parameter 'foo' required is a major"),
    ]);
  });

  test('changing a named parameter from required to optional is a minor', () => {
    expect(
      visitParameters(
        {
          named: [{ type: 'int', required: true, name: 'foo' }],
          positional: [],
        },
        {
          named: [{ type: 'int', required: false, name: 'foo' }],
          positional: [],
        },
      ),
    ).toEqual([
      Semver.minor("Making the named parameter 'foo' optional is a minor"),
    ]);
  });

  test('changing a positional parameter from required to optional is a minor', () => {
    expect(
      visitParameters(
        {
          named: [],
          positional: [{ type: 'int', required: true, name: 'foo' }],
        },
        {
          named: [],
          positional: [{ type: 'int', required: false, name: 'foo' }],
        },
      ),
    ).toEqual([
      Semver.minor("Making the positional parameter 'foo' optional is a minor"),
    ]);
  });

  test('changing a positional parameter from optional to required is a major', () => {
    expect(
      visitParameters(
        {
          named: [],
          positional: [{ type: 'int', required: false, name: 'foo' }],
        },
        {
          named: [],
          positional: [{ type: 'int', required: true, name: 'foo' }],
        },
      ),
    ).toEqual([
      Semver.major("Making the positional parameter 'foo' required is a major"),
    ]);
  });

  test('changing the type of a named parameter is a major', () => {
    expect(
      visitParameters(
        {
          named: [{ type: 'int', required: true, name: 'foo' }],
          positional: [],
        },
        {
          named: [{ type: 'String', required: true, name: 'foo' }],
          positional: [],
        },
      ),
    ).toEqual([
      Semver.major("Changing the type of the named parameter 'foo' is a major"),
    ]);
  });
  test('changing the type of a positional parameter is a major', () => {
    expect(
      visitParameters(
        {
          named: [],
          positional: [{ type: 'int', required: true, name: 'foo' }],
        },
        {
          named: [],
          positional: [{ type: 'String', required: true, name: 'foo' }],
        },
      ),
    ).toEqual([
      Semver.major("Changing the type of the parameter 'foo' is a major"),
    ]);
  });

  test('reordering positional parameters is a major', () => {
    expect(
      visitParameters(
        {
          named: [],
          positional: [
            { type: 'int', required: true, name: 'foo' },
            { type: 'String', required: true, name: 'bar' },
          ],
        },
        {
          named: [],
          positional: [
            { type: 'String', required: true, name: 'bar' },
            { type: 'int', required: true, name: 'foo' },
          ],
        },
      ),
    ).toEqual([
      Semver.major("Changing the type of the parameter 'foo' is a major"),
      Semver.major("Changing the type of the parameter 'bar' is a major"),
    ]);
  });
  test('reordering named parameters has no semver', () => {
    expect(
      visitParameters(
        {
          named: [
            { type: 'int', required: true, name: 'foo' },
            { type: 'int', required: true, name: 'bar' },
          ],
          positional: [],
        },
        {
          named: [
            { type: 'int', required: true, name: 'bar' },
            { type: 'int', required: true, name: 'foo' },
          ],
          positional: [],
        },
      ),
    ).toEqual([]);
  });

  test('changing the name of a named parameter is a major', () => {
    expect(
      visitParameters(
        {
          named: [{ type: 'int', required: true, name: 'foo' }],
          positional: [],
        },
        {
          named: [{ type: 'int', required: true, name: 'bar' }],
          positional: [],
        },
      ),
    ).toEqual([
      Semver.major("Removing the named parameter 'foo' is a major"),
      Semver.major("Adding the required parameter 'bar' is a major"),
    ]);
  });
  test('changing the name of a positional parameter has no semver', () => {
    expect(
      visitParameters(
        {
          named: [],
          positional: [{ type: 'int', required: true, name: 'foo' }],
        },
        {
          named: [],
          positional: [{ type: 'int', required: true, name: 'bar' }],
        },
      ),
    ).toEqual([]);
  });
});
