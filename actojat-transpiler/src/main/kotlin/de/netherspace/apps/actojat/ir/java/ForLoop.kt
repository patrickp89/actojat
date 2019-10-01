package de.netherspace.apps.actojat.ir.java

class ForLoop(
        val loopVariable: Assignment,
        val loopCondition: String,
        val loopIncrement: String,
        body: Sequence<Statement>,
        comment: String?
) : Loop(body = body, comment = comment)
