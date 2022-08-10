package com.drawonapp.appleanimation

import android.animation.ValueAnimator
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.TextView
import androidx.core.animation.doOnEnd

class MainActivity : AppCompatActivity() {

    private lateinit var arcAnimation: ArcAnimation

    private lateinit var textView:TextView


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        arcAnimation = findViewById(R.id.arc_animation)

        textView = findViewById(R.id.textView)

        val text_animator = ValueAnimator.ofFloat(1F,0F)
        text_animator.duration = 1500
        text_animator.addUpdateListener {
            textView.alpha = it.animatedValue as Float
        }

        text_animator.doOnEnd {
            val text_animator1 = ValueAnimator.ofFloat(0F,1F)
            text_animator1.duration = 1500
            text_animator1.addUpdateListener {
                textView.alpha = it.animatedValue as Float
            }

            text_animator1.doOnEnd {
                textView.text = "Sending"
                arcAnimation.start_animation(textView)
            }

            text_animator1.start()
        }

        text_animator.start()
    }

}