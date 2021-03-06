// Copyright 2015 ThoughtWorks, Inc.

// This file is part of getgauge/Intellij-plugin.

// getgauge/Intellij-plugin is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// getgauge/Intellij-plugin is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with getgauge/Intellij-plugin.  If not, see <http://www.gnu.org/licenses/>.

package com.thoughtworks.gauge.language.psi;

import com.intellij.navigation.ItemPresentation;
import com.intellij.psi.PsiElement;
import com.intellij.psi.PsiReference;
import com.thoughtworks.gauge.StepValue;

import java.util.List;

public interface SpecStep extends SpecNamedElement {

    List<SpecArg> getArgList();

    List<SpecStaticArg> getStaticArgList();

    StepValue getStepValue();

    String getName();

    PsiElement setName(String newName);

    PsiElement getNameIdentifier();

    ItemPresentation getPresentation();

    SpecTable getInlineTable();

    PsiReference getReference();
}
