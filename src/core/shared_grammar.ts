import { Semver } from "./models";

export interface ParametersGrammar {
  named: ParameterGrammar[];
  positional: ParameterGrammar[];
}

export interface ParameterGrammar {
  type: string;
  name: string;
  required: boolean;
}

export function visitParameters(
  base: ParametersGrammar | undefined,
  target: ParametersGrammar,
): Semver[] {
  return [
    visitPositionalParameters(base?.positional ?? [], target.positional),
    visitNamedParameters(base?.named ?? [], target.named),
  ].flat();
}

function visitPositionalParameters(
  base: ParameterGrammar[],
  target: ParameterGrammar[],
): Semver[] {
  let semver: Semver[] = [];

  let length = Math.max(base.length, target.length);
  for (let i = 0; i < length; i++) {
    let baseParam = base[i];
    let targetParam = target[i];

    if (baseParam != null && targetParam == null) {
      // parameter was removed
      semver.push(
        Semver.major(`Removing the parameter '${baseParam.name}' is a major`),
      );
    } else if (baseParam == null && targetParam != null) {
      // parameter was added
      if (i >= target.length - 1 && !targetParam.required) {
        // adding a positional parameter is ONLY a minor IFF
        // its optional and is added to the end of the list
        semver.push(
          Semver.minor(
            `Adding the optional parameter '${targetParam.name}' is a minor`,
          ),
        );
      } else {
        semver.push(
          Semver.major(
            `Adding the required parameter '${targetParam.name}' is a major`,
          ),
        );
      }
    }

    // only check the type if the parameter wasn't added/removed
    if (baseParam != null && targetParam != null) {
      if (baseParam.required == false && targetParam.required == true) {
        // parameter goes from optional to required
        semver.push(
          Semver.major(
            `Making the positional parameter '${targetParam.name}' required is a major`,
          ),
        );
      }

      if (baseParam.required == true && targetParam.required == false) {
        // parameter goes from required to optional
        semver.push(
          Semver.minor(
            `Making the positional parameter '${targetParam.name}' optional is a minor`,
          ),
        );
      }

      if (baseParam.type !== targetParam.type) {
        // parameter's type was changed
        semver.push(
          Semver.major(
            `Changing the type of the parameter '${baseParam.name}' is a major`,
          ),
        );
      }
    }
  }

  return semver;
}

function visitNamedParameters(
  base: ParameterGrammar[],
  target: ParameterGrammar[],
): Semver[] {
  let semver: Semver[] = [];

  let baseKeyMap = base.reduce<{ [key: string]: ParameterGrammar }>(
    (acc, p) => ({ ...acc, [p.name]: p }),
    {},
  );
  let baseKeys = Object.keys(baseKeyMap);

  let targetKeyMap = target.reduce<{ [key: string]: ParameterGrammar }>(
    (acc, p) => ({ ...acc, [p.name]: p }),
    {},
  );
  let targetKeys = Object.keys(targetKeyMap);

  let removedKeys = baseKeys.filter((k) => !targetKeys.includes(k));
  removedKeys.forEach((key) =>
    semver.push(
      Semver.major(`Removing the named parameter '${key}' is a major`),
    ),
  );

  let addedKeys = targetKeys.filter((k) => !baseKeys.includes(k));
  for (let key of addedKeys) {
    if (targetKeyMap[key]!.required) {
      // adding a required named parameter is a major
      semver.push(
        Semver.major(`Adding the required parameter '${key}' is a major`),
      );
    } else {
      // adding an optional named parameter is a minor
      semver.push(
        Semver.minor(`Adding the optional parameter '${key}' is a minor`),
      );
    }
  }

  let sharedKeys = baseKeys.filter((k) => targetKeys.includes(k));
  for (let key of sharedKeys) {
    let baseParam = baseKeyMap[key]!;
    let targetParam = targetKeyMap[key]!;

    if (baseParam.required == false && targetParam.required == true) {
      // parameter goes from optional to required
      semver.push(
        Semver.major(`Making the named parameter '${key}' required is a major`),
      );
    }

    if (baseParam.required == true && targetParam.required == false) {
      // parameter goes from required to optional
      semver.push(
        Semver.minor(`Making the named parameter '${key}' optional is a minor`),
      );
    }

    if (baseParam.name != targetParam.name) {
      // parameter's name was changed
      semver.push(
        Semver.major(
          `Changing the name of the named parameter '${key}' is a major`,
        ),
      );
    }

    if (baseParam.type !== targetParam.type) {
      // parameter's type was changed
      semver.push(
        Semver.major(
          `Changing the type of the named parameter '${key}' is a major`,
        ),
      );
    }
  }

  return semver;
}
