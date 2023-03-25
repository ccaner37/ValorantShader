using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationsScript : MonoBehaviour
{
    [SerializeField]
    private Animator _animator;

    private Vector3 _firstRotation, _firstInputPos, _targetRotation;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            _animator.SetTrigger(("VandalAnimation"));
        }

        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            _animator.SetTrigger(AnimatorHashCode("VandalIdleAnimation"));
        }

        if (Input.GetMouseButtonDown(0))
        {
            _firstRotation = transform.eulerAngles;
            _firstInputPos = Input.mousePosition;

            _animator.enabled = false;
        }

        if (Input.GetMouseButton(0))
        {
            Vector3 inputPos = Input.mousePosition;
            Vector3 diff = _firstInputPos - inputPos;
            Vector3 newRotation = new Vector3(_firstRotation.x, _firstRotation.y + diff.x, _firstRotation.z - diff.y);
            transform.eulerAngles = newRotation;
        }

        if (Input.GetMouseButtonUp(0))
        {
            _animator.enabled = true;
        }
    }

    private int AnimatorHashCode(string parameter)
    {
        return Animator.StringToHash(parameter);
    }
}
