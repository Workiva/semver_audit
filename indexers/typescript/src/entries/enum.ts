import ts from 'typescript';
import { Entry } from './base_entry';

export class EnumEntry extends Entry<ts.EnumDeclaration> {
  type = 'enum';

  grammar() {
    let members = this.declaration.members.map((member) => {
      let type =
        member.initializer && ts.isStringLiteralLike(member.initializer)
          ? 'string'
          : 'number';

      return {
        name: member.name.getText(),
        type: type,
      };
    });

    return {
      name: this.declaration.name.getText(),
      values: members,
    };
  }

  signatureDeclaration(): ts.Declaration {
    return this.declaration;
  }
}
