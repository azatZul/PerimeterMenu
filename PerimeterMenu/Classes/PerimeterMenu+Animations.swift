// The MIT License
//
// Copyright (c) 2018 7bit (Alex Kremer, Valera Chevtaev)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

extension PerimeterMenu {

    func showMenu(for state: State, animated: Bool) {
        switch state {
        case .expanded:
            expandMenu(animated: animated)
        case .collapsed:
            collapseMenu(animated: animated)
        }
    }

    func expandMenu(animated: Bool) {
        print("expand menu")
        let animations: VoidBlock = { [weak self] in
            guard let sself = self else { return }
            for (index, button) in sself.menu.enumerated() {
                button.center = sself.buttonsPositions[index]
                button.alpha = 1.0
            }
        }

        containerView.isHidden = false
        let duration = animated ? animationDuration : 0
        animator.animate(withDuration: duration,
                         animations: animations,
                         completion: nil)
    }

    func collapseMenu(animated: Bool) {
        print("collapse menu")
        let animations: VoidBlock = { [weak self] in
            guard let sself = self else { return }
            sself.enableGestures(false)
            sself.menu.forEach {
                $0.center = sself.centerPoint
                $0.alpha = 0.0
            }
        }
        let completion: (Bool) -> Void = { _ in
            self.containerView.isHidden = true
            self.enableGestures(true)
        }

        let duration = animated ? animationDuration : 0
        animator.animate(withDuration: duration,
                         animations: animations,
                         completion: completion)
    }

    var centerPoint: CGPoint {
        return CGPoint(x: containerView.bounds.width/2,
                       y: containerView.bounds.height/2)
    }

    private var animator: MenuAnimator {
        return AnimatorFactory.createAnimator(forStyle: internalAnimationStyle)
    }
}