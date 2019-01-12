package de.netherspace.apps.actojat.intermediaterepresentation.java;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ArgumentDeclaration extends JavaLanguageConstruct {

  private String type;
  private String name;

}
